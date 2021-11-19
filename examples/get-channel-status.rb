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
  doc = Nokogiri::Slop(st.xml)
  channel = doc.xpath("/dashboardStatus")
  puts "# #{st.name}"
  puts "  #{st.id}"
  xconnectors = channel.xpath("childStatuses/dashboardStatus")
  xconnectors.each do |xc|
    name = xc.xpath("name").text
    meta = xc.xpath("metaDataId").text
    prefix = "  > " 
    puts prefix + "(#{meta}) #{name}"
    prefix = "    * "
    puts prefix + xc.xpath("statusType").text
    puts prefix + "state: #{xc.xpath("state").text}"
    puts prefix + "queued: #{xc.xpath("queued").text}"
    xc.xpath("statistics/entry").each do |entry|
      prefix = "    - "
      key = entry.xpath("com.mirth.connect.donkey.model.message.Status").text
      value = entry.xpath("long").text
      puts prefix + "#{key}: #{value}"
    end
  end
end

mapi.logout
