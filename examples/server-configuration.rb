#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:development, :default)

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

mapi = Wobmire::Api.new(options)
unless mapi.login(get_user, get_passwd)
  puts "no valid session found, sorry"
  exit
end

response = mapi.get("server/configuration")

if response.success?
  puts response.body
else
  puts response.error_messages.join("; ")
end

mapi.logout
