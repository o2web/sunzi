module Sunzi
  module Cli::Capistrano
    extend self

    attr_accessor :env
    @env = {}

    def load_env(stage)
      deploy_path = File.expand_path('config/deploy.rb')
      stage_path = File.expand_path("config/deploy/#{stage}.rb")
      instance_eval(File.read(deploy_path), deploy_path)
      instance_eval(File.read(stage_path), stage_path)
      @env = HashWithIndifferentAccess.new(@env)
    end

    def lock(version); end
    def namespace(options = {}); end

    def set(key, value)
      @env[key] = value
    end

    def fetch(key, value = nil)
      if @env.has_key?(key)
        @env[key]
      else
        @env[key] = value
      end
    end

    def server(name, properties = {})
      @env[:server] = {name: name}.merge(properties)
    end

    def method_missing(name, *args, &block)
      if caller.join.include? 'load_env'
        # do nothing
      else
        super
      end
    end
  end
end
