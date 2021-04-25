module Mirth
  autoload :Api, 'mirth/api'

  def self.config
    yield self
  end

  # baseurl
  mattr_accessor :baseurl
  @@baseurl = 'https://localhost:8443/api'
end
