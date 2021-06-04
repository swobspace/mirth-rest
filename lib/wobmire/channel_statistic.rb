module Wobmire
  class ChannelStatistic
    attr_reader :xml, :statistics
    Result = ImmutableStruct.new( :success?, :error_messages, :channel_statistics )

    # Wobmire::ChannelStatistic.fetch(connection)
    #
    # - connection: valid Wobmire::Api Connection (always authenticated)
    # 
    # returns result:
    # - result.success?
    # - result.error_messages: array; empty in case of success
    # - result.channel_statistics: list of Wobmire::ChannelStatistic instances
    #
    # generic fetch
    def self.fetch(connection)
      channel_statistics = []
      result = Wobmire::XmlList.fetch(connection, "channels/statistics", "channelStatistics")
      unless result.success?
        return Result.new(
          success: result.success?, 
          error_messages: result.error_messages,
          channel_statistics: []
        )
      end
      result.xml_list.each do |xml|
        channel_statistics << Wobmire::ChannelStatistic.new(xml)
      end
      return Result.new(
        success: true,
        error_messages: [],
        channel_statistics: channel_statistics
      )
    end

    # Wobmire::ChannelStatistics.new(xml)
    #
    def initialize(xml)
      @xml = xml
      @statistics = Hash.from_xml(xml)
      @statistics = @statistics["channelStatistics"]
    end

    def channel_id
      statistics['channelId']
    end
    
    def server_id
      statistics['serverId']
    end
    
    def queued
      statistics['queued'].to_i
    end
    
  end
end
