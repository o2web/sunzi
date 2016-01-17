module Sunzi
  module Cli::Database
    extend self

    attr_accessor :env

    def load_env(stage)
      path = File.expand_path('config/database.yml')
      @env = YAML.load(File.read(path))[stage]
      scope_keys
      @env = HashWithIndifferentAccess.new(@env)
    end

    private

    def scope_keys
      @env = @env.reduce({}) do |env, (key, value)|
        env[:"db_#{key}"] = value
        env
      end
    end
  end
end
