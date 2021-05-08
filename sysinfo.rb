#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/mirth.rb'

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

mapi = Mirth::Api.new(options)
if mapi.login(get_user, get_passwd)
  puts "valid session"
else
  puts "no valid session found, sorry"
  exit
end

[ Mirth::SystemInfo.fetch(mapi).info, Mirth::SystemStats.fetch(mapi).stats ].each do |sys|

  sys.attributes.each do |k,v|
    puts "#{k}: #{v}"
  end
end

mapi.logout
