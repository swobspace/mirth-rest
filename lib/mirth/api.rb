module Mirth
  class Api
    attr_reader :options, :connection

    # options:
    # * :url https://<host>:<port>/api
    # * :params
    # * :headers
    # * :requests
    # * :ssl
    # * :proxy
    #
    def initialize(options = {})
      @options = options
      @connection = Faraday.new(options)
      @session = nil
    end

    def login(user, passwd)
      response = connection.post "users/_login" do |req|
        req.headers[:content_type] = "application/x-www-form-urlencoded"
        req.headers[:accept]       = "application/xml"
        req.params[:username]      = user
        req.params[:password]      = passwd
      end

      if response.status == 200
        @session = response.headers['Set-Cookie']
        return true
      else
        @session = nil
        return false
      end 
    end
     
    def valid_session?
      !!@session
    end

    # response = get(suburi)
    # - response.success?
    # - response.headers
    # - response.status
    # - response.body
    #
    def get(suburi)
      response = connection.get suburi do |req|
        req.headers['COOKIE'] = session
      end
    end

  private
    attr_reader :session

  end
end
