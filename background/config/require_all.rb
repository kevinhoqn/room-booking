require 'dotenv/load'
require 'date'
require 'byebug'
require "google/cloud/pubsub"
require 'action_mailer'
require 'sidekiq'
require "httparty"

Dir.glob(File.join(File.dirname(__FILE__), "../config/*.rb")) do |c|
  require(c)
end

# Load application's app / class
Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*.rb")) do |c|
  require(c)
end