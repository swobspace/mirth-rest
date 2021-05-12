#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:development, :default)
require_relative 'lib/mirth.rb'

Dotenv.load
@cli = HighLine.new

def get_user(prompt="Enter Login")
  ENV['USER'] || @cli.ask(prompt) { |q| q.default = 'api' }
end

def get_passwd(prompt="Enter Password")
  ENV['PASSWD'] || @cli.ask(prompt) { |q| q.echo = false }
end

def get_url(prompt="Enter URL")
  ENV['URL'] || @cli.ask(prompt) { |q| q.default = 'https://localhost:8443/api' }
end


options = {
  url: get_url,
  ssl: { verify: false },
}

mapi = Mirth::Api.new(options)
if mapi.login(get_user, get_passwd)
  puts "valid session"
else
  puts "no valid session found, sorry"
  exit
end

result = Mirth::Channel.fetch(mapi)
unless result.success?
  puts result.error_messages.join("; ")
  exit 1
end

result.channels.each do |ch|
  printf "%40s : %s\n", ch.name, ch.channel['exportData']['metadata']['pruningSettings'].to_s
end

mapi.logout
