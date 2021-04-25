module Mirth
  class Channel
    attr_reader :xml, :json
    Result = ImmutableStruct.new( :success?, :error_messages, :channels )

    # Mirth::Channel.fetch(connection)
    #
    # - connection: valid Mirth::Api Connection (always authenticated)
    # 
    # returns result:
    # - result.success?
    # - result.error_messages: array; empty in case of success
    # - result.channels: list of Mirth::Channel instances
    #
    # generic fetch
    def self.fetch(connection)
      channels = []
      result = Mirth::XmlList.fetch(connection, "channels", "channel")
      unless result.success?
        return Result.new(
          success: result.success?, 
          error_messages: result.error_messages,
          channels: []
        )
      end
      result.xml_list.each do |xml|
        channels << Mirth::Channel.new(xml)
      end
      return Result.new(
        success: true,
        error_messages: [],
        channels: channels
      )
    end

    # Mirth::Channel.new(xml)
    #
    def initialize(xml)
      @xml = xml
      @json = Hash.from_xml(xml).to_json
    end
    
  end
end
