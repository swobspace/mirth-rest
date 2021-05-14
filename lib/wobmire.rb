require 'active_support/core_ext/hash'
require 'active_support/core_ext/module/attribute_accessors'
require 'json'
require 'immutable-struct'
require 'faraday'
require 'nokogiri'

require 'wobmire/api'
require 'wobmire/xml_list'
require 'wobmire/channel'
require 'wobmire/channel_name'
require 'wobmire/channel_statistic'
require 'wobmire/channel_status'
require 'wobmire/system_info'
require 'wobmire/system_stats'

module Wobmire

  def self.config
    yield self
  end

  # baseurl
  mattr_accessor :baseurl
  self.baseurl = 'https://localhost:8443/api'
end
