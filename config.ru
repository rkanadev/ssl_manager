#\ -o 0.0.0.0 -p 4567
require 'bundler/setup'
require 'json'

require './ssl_manager.rb'

config_file = File.read('ssl_manager_config.json')
ssl_config = JSON.parse(config_file)
SSLManager.set :ssl_config, ssl_config

run SSLManager
