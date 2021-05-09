require 'active_support/core_ext/hash'
require 'active_support/core_ext/module/attribute_accessors'
require 'json'
require 'immutable-struct'
require 'faraday'
require 'nokogiri'

require 'mirth/api'
require 'mirth/xml_list'
require 'mirth/channel'
require 'mirth/channel_name'
require 'mirth/channel_statistic'
require 'mirth/channel_status'
require 'mirth/system_info'
require 'mirth/system_stats'

module Mirth

  def self.config
    yield self
  end

  # baseurl
  mattr_accessor :baseurl
  self.baseurl = 'https://localhost:8443/api'
end
