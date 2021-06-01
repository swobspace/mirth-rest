module Wobmire
  class ServerSettings
    attr_reader :xml, :settings
    Result = ImmutableStruct.new( :success?, :error_messages, :settings )

    ATTRIBUTES = [:environment_name, :server_name]

    # Wobmire::ServerSettings.fetch(connection)
    #
    # - connection: valid Wobmire::Api Connection (always authenticated)
    # 
    # returns result:
    # - result.success?
    # - result.error_messages: array; empty in case of success
    # - result.settings: ServerSettings.new
    #
    def self.fetch(connection)
      result = Wobmire::XmlList.fetch(connection, "server/settings", "serverSettings")
      unless result.success?
        return Result.new(
          success: result.success?, 
          error_messages: result.error_messages,
          settings: nil
        )
      end
      xml = result.xml_list.first
      return Result.new(
        success: true,
        error_messages: [],
        settings: Wobmire::ServerSettings.new(xml)
      )
    end

    # Wobmire::ServerSettings.new(xml)
    #
    def initialize(xml)
      @xml = xml
      @settings = Hash.from_xml(xml)
      @settings = @settings["serverSettings"]
    end

    def environment_name
      settings['environmentName']
    end

    def server_name
      settings['serverName']
    end

    def attributes
      {}.tap do |hash|
        ATTRIBUTES.each do |a|
          hash[a] = self.send(a.to_s)
        end
      end
    end
  end
end
