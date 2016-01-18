require 'open3'
require 'ostruct'
require 'net/ssh'

module Sunzi
  class Cli < Thor
    include Thor::Actions

    desc 'create', 'Create sunzi project'
    def create
      do_create
    end

    desc 'deploy [stage] [role] [--sudo]', 'Deploy sunzi project'
    method_options :sudo => false
    def deploy(first, *args)
      do_deploy(first, *args)
    end

    desc 'compile', 'Compile sunzi project'
    def compile(first, *args)
      do_compile(first, *args)
    end

    desc 'version', 'Show version'
    def version
      puts Gem.loaded_specs['sunzi'].version.to_s
    end

    no_tasks do
      include Sunzi::Utility

      def self.source_root
        File.expand_path('../../',__FILE__)
      end

      def do_create
        directory 'templates/create', 'config/sunzi'
      end

      def do_deploy(first, *args)
        # compile attributes and recipes
        do_compile(first, *args)

        # The host key might change when we instantiate a new VM, so
        # we remove (-R) the old host key from known_hosts.
        `ssh-keygen -R #{@host} 2> /dev/null`

        remote_commands = <<-EOS
        rm -rf ~/sunzi &&
        mkdir ~/sunzi &&
        cd ~/sunzi &&
        tar xz &&
        #{@sudo}bash install.sh
        EOS

        remote_commands.strip! << ' && rm -rf ~/sunzi' if @config['preferences'] and @config['preferences']['erase_remote_folder']

        local_commands = <<-EOS
        cd compiled
        tar cz . | ssh -o 'StrictHostKeyChecking no' #{@user}@#{@host} -p #{@port} '#{remote_commands}'
        EOS

        Open3.popen3(local_commands) do |stdin, stdout, stderr|
          stdin.close
          t = Thread.new do
            while (line = stderr.gets)
              print line.color(:red)
            end
          end
          while (line = stdout.gets)
            print line.color(:green)
          end
          t.join
        end
      end

      def do_compile(first, *args)
        load_env(first, *args)

        compile_attributes
        copy_remote_recipes
        copy_local_files
        build_install
      end

      def load_env(first, *args)
        @stage = first
        @role = args[0]

        abort_with 'You must have a sunzi folder' unless File.exists?(based("sunzi.yml"))
        abort_with "#{@role} doesn't exist!"       unless File.exists?(based("roles/#{@role}.sh"))

        cap = Capistrano.load_env(@stage)
        if options.sudo?
          @sudo = 'sudo '
          @user = cap[:admin_name]
        else
          @user = cap[:deployer_name]
        end
        @host = cap[:server]
        @port = cap[:port]

        @config = YAML.load(File.read(based("sunzi.yml")))

        @attributes = Database.load_env(@stage)
          .merge(cap.slice(:ruby_version, :deployer_name))
          .merge(Secrets.load_env(@stage).slice(:deployer_password, :deployer_public_key))
          .merge(
            env_stage: @stage,
            env_role: @role,
            env_sudo: options.sudo?,
            env_user: @user,
            env_host: @host,
            env_port: @port
          )
          .merge(@config['attributes'] || {})
      end

      def compile_attributes
        # Break down attributes into individual files
        @attributes.each {|key, value| create_file compiled("attributes/#{key}"), value }
        @attributes = OpenStruct.new(@attributes)
      end

      def copy_remote_recipes
        # Retrieve remote recipes via HTTP
        cache_remote_recipes = @config['preferences'] && @config['preferences']['cache_remote_recipes']
        (@config['recipes'] || []).each do |key, value|
          next if cache_remote_recipes and File.exists?(compiled("recipes/#{key}.sh"))
          get value, "compiled/recipes/#{key}.sh"
        end
      end

      def copy_local_files
        files = Dir["{config/sunzi/recipes,config/sunzi/roles,config/sunzi/files}/**/*"].select { |file| File.file?(file) }

        files.each do |file|
          template based(file), compiled(file)
        end

        (@config['files'] || []).each do |file|
          template based(file), compiled("files/#{File.basename(file)}")
        end
      end

      def build_install
        _install_path = compiled("_install.sh")
        template based("install.sh"), _install_path
        content = File.binread(_install_path) << "\n" << File.binread(compiled("roles/#{@role}.sh"))
        create_file compiled("install.sh"), content
      end

      def based(file)
        File.expand_path("config/sunzi/#{file.sub('config/sunzi/', '')}")
      end

      def compiled(file)
        File.expand_path("compiled/#{file.sub('config/sunzi/', '')}")
      end
    end
  end
end
