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
if mapi.login(get_user, get_passwd)
  puts "valid session"
else
  puts "no valid session found, sorry"
  exit
end

result = Wobmire::ChannelName.fetch(mapi)
unless result.success?
  puts result.error_messages.join("; ")
  exit 1
end

chash = {}.tap do |hash|
  result.channel_names.each do |cn|
    hash[cn.id] = cn.name
  end
end

result = Wobmire::ChannelStatistic.fetch(mapi)

sumqueue = 0
warning = []

result.channel_statistics.each do |chan|
  msg = "WARN:: #{chash[chan.channel_id]}: #{chan.queued}"
  if chan.queued > 0
    sumqueue += chan.queued
    warning << msg
  end
end

version = mapi.get("server/version").body
puts "Mirth version: #{version}"

puts "#{warning.join("\n")}"
puts "Summe: #{sumqueue}"

mapi.logout
