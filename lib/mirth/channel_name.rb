module Mirth
  class ChannelName
    attr_reader :xml, :channel_name
    Result = ImmutableStruct.new( :success?, :error_messages, :channel_names )

    # Mirth::ChannelName.fetch(connection)
    #
    # - connection: valid Mirth::Api Connection (always authenticated)
    # 
    # returns result:
    # - result.success?
    # - result.error_messages: array; empty in case of success
    # - result.channel_names: list of Mirth::ChannelName instances
    #
    # generic fetch
    def self.fetch(connection)
      channel_names = []
      result = Mirth::XmlList.fetch(connection, "channels/idsAndNames", "entry")
      unless result.success?
        return Result.new(
          success: result.success?, 
          error_messages: result.error_messages,
          channel_names: []
        )
      end
      result.xml_list.each do |xml|
        channel_names << Mirth::ChannelName.new(xml)
      end
      return Result.new(
        success: true,
        error_messages: [],
        channel_names: channel_names
      )
    end

    # Mirth::ChannelName.new(xml)
    #
    def initialize(xml)
      @xml = xml
      @channel_name = Hash.from_xml(xml)
      @channel_name = @channel_name["entry"]
    end

    def id
      channel_name['string'][0]
    end
    
    def name
      channel_name['string'][1]
    end
  end
end
