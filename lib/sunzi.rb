require 'thor'
require 'rainbow'
require 'yaml'
require 'sunzi/version'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/ordered_hash'
require 'active_support/hash_with_indifferent_access'

# Starting 2.0.0, Rainbow no longer patches string with the color method by default.
require 'rainbow/version'
require 'rainbow/ext/string' unless Rainbow::VERSION < '2.0.0'

module Sunzi
  if ENV['RAILS_ENV'] == 'development'
    autoload :Capistrano, './lib/sunzi/cli/capistrano'
    autoload :Database,   './lib/sunzi/cli/database'
    autoload :Secrets,    './lib/sunzi/cli/secrets'
    autoload :Cli,        './lib/sunzi/cli'
    autoload :Logger,     './lib/sunzi/logger'
    autoload :Utility,    './lib/sunzi/utility'
  else
    autoload :Capistrano, 'sunzi/cli/capistrano'
    autoload :Database,   'sunzi/cli/database'
    autoload :Secrets,    'sunzi/cli/secrets'
    autoload :Cli,        'sunzi/cli'
    autoload :Logger,     'sunzi/logger'
    autoload :Utility,    'sunzi/utility'
  end
end
