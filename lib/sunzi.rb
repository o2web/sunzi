require 'active_support/all'
require 'thor'
require 'rainbow'
# Starting 2.0.0, Rainbow no longer patches string with the color method by default.
require 'rainbow/version'
require 'rainbow/ext/string' unless Rainbow::VERSION < '2.0.0'
require 'yaml'
require 'sunzi/utility'
require 'sunzi/cli'
require 'sunzi/cli/capistrano'
require 'sunzi/cli/database'
require 'sunzi/cli/secrets'
require 'sunzi/logger'
require 'sunzi/version'

module Sunzi
end
