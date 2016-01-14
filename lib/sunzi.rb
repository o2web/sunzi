require 'thor'
require 'rainbow'
require 'yaml'

# Starting 2.0.0, Rainbow no longer patches string with the color method by default.
require 'rainbow/version'
require 'rainbow/ext/string' unless Rainbow::VERSION < '2.0.0'

module Sunzi
  autoload :Cli,        'sunzi/cli'
  autoload :Logger,     'sunzi/logger'
  autoload :Utility,    'sunzi/utility'
end
