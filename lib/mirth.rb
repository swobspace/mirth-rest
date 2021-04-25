require 'active_support/core_ext/module/attribute_accessors'
require_relative 'mirth/api'

module Mirth
  # autoload :Api, './mirth/api.rb'

  def self.config
    yield self
  end

  # baseurl
  mattr_accessor :baseurl
  self.baseurl = 'https://localhost:8443/api'
end
