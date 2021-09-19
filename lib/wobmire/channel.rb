module Wobmire
  class Channel
    attr_reader :xml, :properties
    Result = ImmutableStruct.new( :success?, :error_messages, :channels )

    # Wobmire::Channel.fetch(connection)
    #
    # - connection: valid Wobmire::Api Connection (always authenticated)
    # 
    # returns result:
    # - result.success?
    # - result.error_messages: array; empty in case of success
    # - result.channels: list of Wobmire::Channel instances
    #
    # generic fetch
    def self.fetch(connection)
      channels = []
      result = Wobmire::XmlList.fetch(connection, "channels", "//channel")
      unless result.success?
        return Result.new(
          success: result.success?, 
          error_messages: result.error_messages,
          channels: []
        )
      end
      result.xml_list.each do |xml|
        channels << Wobmire::Channel.new(xml)
      end
      return Result.new(
        success: true,
        error_messages: [],
        channels: channels
      )
    end

    # Wobmire::Channel.new(xml)
    #
    def initialize(xml)
      @xml = xml
      channel = Hash.from_xml(xml)
      @properties = channel["channel"]
    end

    def version
      properties['version']
    end

    def id
      properties['id']
    end
    
    def name
      properties['name']
    end
    
    def description
      properties['description']
    end
    
  end
end
