#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:development, :default)

Dotenv.load
@cli = HighLine.new

def get_user(prompt="Enter Login")
  ENV['APIUSER'] || @cli.ask(prompt) { |q| q.default = 'api' }
end

def get_passwd(prompt="Enter Password")
  ENV['APIPASSWD'] || @cli.ask(prompt) { |q| q.echo = false }
end

def get_url(prompt="Enter URL")
  ENV['APIURL'] || @cli.ask(prompt) { |q| q.default = 'https://localhost:8443/api' }
end

def get_channelid(prompt="Enter ChannelId (empty = all channels)")
  ENV['CHANNELID'] || @cli.ask(prompt) { |q| q.default = nil }
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

result = Wobmire::ChannelStatus.fetch(mapi, get_channelid)
unless result.success?
  puts result.error_messages.join("; ")
  exit 1
end

result.channel_statuses.each do |st|
  # doc = Nokogiri::XML(st.xml)
  # x = doc.xpath("//childStatuses/dashboardStatus")
  # puts Hash.from_xml(x.to_s).to_yaml
  puts st.xml
end

mapi.logout
