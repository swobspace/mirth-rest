#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:development, :default)
require 'mirth'

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

[ Mirth::SystemInfo.fetch(mapi).info ].each do |sys|
  sys.attributes.each do |k,v|
    puts "#{k}: #{v}"
  end
end
stats =  Mirth::SystemStats.fetch(mapi).stats

printf "cpu usage: %4.2f %%\n", stats.cpu_usage_pct.to_f
printf "Memory used/free/max (MByte): %dM / %dM / %dM\n", 
       stats.allocated_memory_bytes.to_i / 1024**2,
       stats.free_memory_bytes.to_i / 1024**2,
       stats.max_memory_bytes.to_i / 1024**2
printf "Disk used/free/max (GByte): %dG / %dG / %dG\n", 
       (stats.disk_total_bytes.to_i - stats.disk_free_bytes.to_i) / 1024**3,
       stats.disk_free_bytes.to_i / 1024**3,
       stats.disk_total_bytes.to_i / 1024**3,


mapi.logout
