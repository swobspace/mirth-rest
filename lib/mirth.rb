require 'active_support/core_ext/hash'
require 'active_support/core_ext/module/attribute_accessors'
require 'json'

require_relative 'mirth/api'
require_relative 'mirth/xml_list'
require_relative 'mirth/channel'
require_relative 'mirth/channel_statistic'
require_relative 'mirth/system_info'
require_relative 'mirth/system_stats'

module Mirth

  def self.config
    yield self
  end

  # baseurl
  mattr_accessor :baseurl
  self.baseurl = 'https://localhost:8443/api'
end
