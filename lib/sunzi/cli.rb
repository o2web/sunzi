require 'open3'
require 'ostruct'
require 'net/ssh'

module Sunzi
  class Cli < Thor
    include Thor::Actions

    desc 'create', 'Create sunzi project'
    def create(project = 'sunzi')
      do_create(project)
    end

    desc 'deploy [stage] [role] [--sudo]', 'Deploy sunzi project'
    method_options :sudo => false
    def deploy(first, *args)
      do_deploy(first, *args)
    end

    desc 'compile', 'Compile sunzi project'
    def compile(role = nil)
      do_compile(role)
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

      def do_create(project)
        copy_file 'templates/create/.gitignore',         "#{project}/.gitignore"
        copy_file 'templates/create/sunzi.yml',          "#{project}/sunzi.yml"
        copy_file 'templates/create/install.sh',         "#{project}/install.sh"
        copy_file 'templates/create/recipes/sunzi.sh',   "#{project}/recipes/sunzi.sh"
        copy_file 'templates/create/roles/db.sh',        "#{project}/roles/db.sh"
        copy_file 'templates/create/roles/web.sh',       "#{project}/roles/web.sh"
        copy_file 'templates/create/files/.gitkeep',     "#{project}/files/.gitkeep"
      end

      def do_deploy(first, *args)
        stage = first
        role = args[0]

        cap = Capistrano.load_env(stage)

        if options.sudo?
          sudo = 'sudo '
          user = cap[:sys_admin]
        else
          user = cap[:server][:user]
        end
        host = cap[:server][:name]
        port = cap[:port]

        endpoint = "#{user}@#{host}"

        # compile attributes and recipes
        do_compile(role)
        @config = Database.load_env(stage).merge(@config)

        # The host key might change when we instantiate a new VM, so
        # we remove (-R) the old host key from known_hosts.
        `ssh-keygen -R #{host} 2> /dev/null`

        remote_commands = <<-EOS
        rm -rf ~/sunzi &&
        mkdir ~/sunzi &&
        cd ~/sunzi &&
        tar xz &&
        #{sudo}bash install.sh
        EOS

        remote_commands.strip! << ' && rm -rf ~/sunzi' if @config['preferences'] and @config['preferences']['erase_remote_folder']

        local_commands = <<-EOS
        cd compiled
        tar cz . | ssh -o 'StrictHostKeyChecking no' #{endpoint} -p #{port} '#{remote_commands}'
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

      def do_compile(role)
        # Check if you're in the sunzi directory
        abort_with 'You must have a sunzi folder' unless File.exists?(based("sunzi.yml"))
        # Check if role exists
        abort_with "#{role} doesn't exist!" unless File.exists?(based("roles/#{role}.sh"))

        # Load sunzi.yml
        @config = YAML.load(File.read(based("sunzi.yml")))

        # Break down attributes into individual files
        @config['attributes'] ||= {}
        @config['attributes'].each {|key, value| create_file compiled("attributes/#{key}"), value }
        @attributes = OpenStruct.new(@config['attributes'])

        # Retrieve remote recipes via HTTP
        cache_remote_recipes = @config['preferences'] && @config['preferences']['cache_remote_recipes']
        (@config['recipes'] || []).each do |key, value|
          next if cache_remote_recipes and File.exists?(compiled("recipes/#{key}.sh"))
          get value, "compiled/recipes/#{key}.sh"
        end

        copy_local_files(@config)
        build_install(role)
      end

      def copy_local_files(config)
        files = Dir["{config/sunzi/recipes,config/sunzi/roles,config/sunzi/files}/**/*"].select { |file| File.file?(file) }

        files.each do |file|
          template based(file), compiled(file)
        end

        (config['files'] || []).each do |file|
          template based(file), compiled("files/#{File.basename(file)}")
        end
      end

      def build_install(role)
        _install_path = compiled("_install.sh")
        template based("install.sh"), _install_path
        content = File.binread(_install_path) << "\n" << File.binread(compiled("roles/#{role}.sh"))
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
