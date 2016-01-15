module Sunzi
  module Cli::Database
    extend self

    attr_accessor :env
    @env = {}

    def load_env(stage)
      path = File.expand_path('config/database.yml')
      @env = YAML.load(File.read(path))[stage]
    end
  end
end
