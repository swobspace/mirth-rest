#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:development, :default)
require 'active_support/core_ext/hash'

doc = File.open(ARGV[0]) {|f| Nokogiri::XML(f) }

libs = doc.xpath("//codeTemplateLibrary")

libs.each do |lib|
  templ = lib.xpath("//codeTemplates/codeTemplate")
  templ.each do |tpl|
    hash = Hash.from_xml(tpl.to_s)
    hash = hash['codeTemplate']
    
    puts "*** #{hash['name']} ***"
    hash['properties'].each do |k,v|
      puts "#{k}: #{v}\n"
    end
  end
end


