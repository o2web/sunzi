require 'active_support/hash_with_indifferent_access'

module Sunzi
  module Cli::Secrets
    extend self

    attr_accessor :env

    def load_env(stage)
      path = File.expand_path('config/secrets.yml')
      @env = HashWithIndifferentAccess.new(YAML.load(File.read(path))[stage])
    end
  end
end
