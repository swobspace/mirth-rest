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

result = Mirth::ChannelName.fetch(mapi)
unless result.success?
  puts result.error_messages.join("; ")
  exit 1
end

chash = {}.tap do |hash|
  result.channel_names.each do |cn|
    hash[cn.id] = cn.name
  end
end

# result = Mirth::ChannelStatus.fetch(mapi)
# unless result.success?
#   puts result.error_messages.join("; ")
#   exit 1
# end
# chash = {}.tap do |hash|
#   result.channel_statuses.each do |ch|
#     puts "#{ch.id}; #{ch.name}; #{ch.state}; #{ch.status_type}; #{ch.queued}"
#     if ch.status_type == "CHANNEL"
#       hash[ch.id] = [ ch.name, ch.state ]
#     end
#   end
# end

result = Mirth::ChannelStatistic.fetch(mapi)

sumqueue = 0
warning = []

result.channel_statistics.each do |chan|
  msg = "#{chash[chan.channel_id]}: #{chan.queued}"
  if chan.queued > 0
    sumqueue += chan.queued
    warning << msg
  end
end

puts "Summe: #{sumqueue}"
puts "WARN:: #{warning.join("; ")}"

version = mapi.get("server/version").body
puts "Mirth version: #{version}"

mapi.logout
