#!/usr/bin/env ruby

require 'bundler/setup'
require_relative 'lib/mirth_api.rb'
Bundler.require(:default)

Dotenv.load
@cli = HighLine.new

def get_user(prompt="Enter Login")
  ENV['USER'] || @cli.ask(prompt) { |q| q.default = 'api' }
end

def get_passwd(prompt="Enter Password")
  ENV['PASSWD'] || @cli.ask(prompt) { |q| q.echo = false }
end

options = {
  url: 'https://localhost:8443/api',
  ssl: { verify: false },
}

mirth = MirthApi.new(options)
if mirth.login(get_user, get_passwd)
  puts "valid session"
else
  puts "no valid session found, sorry"
  exit
end

mirth.get('users/current')
mirth.get('channels/statistics')
mirth.get('channels/idsAndNames')
mirth.get('server/configuration')
mirth.get('server/version')
