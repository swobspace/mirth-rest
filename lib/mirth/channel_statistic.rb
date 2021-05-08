module Mirth
  class ChannelStatistic
    attr_reader :xml, :channel_statistic
    Result = ImmutableStruct.new( :success?, :error_messages, :channel_statistics )

    # Mirth::Channel.fetch(connection)
    #
    # - connection: valid Mirth::Api Connection (always authenticated)
    # 
    # returns result:
    # - result.success?
    # - result.error_messages: array; empty in case of success
    # - result.channel_statistics: list of Mirth::ChannelStatistics instances
    #
    # generic fetch
    def self.fetch(connection)
      channel_statistics = []
      result = Mirth::XmlList.fetch(connection, "channels/statistics", "channelStatistics")
      unless result.success?
        return Result.new(
          success: result.success?, 
          error_messages: result.error_messages,
          channel_statistics: []
        )
      end
      result.xml_list.each do |xml|
        channel_statistics << Mirth::ChannelStatistic.new(xml)
      end
      return Result.new(
        success: true,
        error_messages: [],
        channel_statistics: channel_statistics
      )
    end

    # Mirth::ChannelStatistics.new(xml)
    #
    def initialize(xml)
      @xml = xml
      @channel_statistic = Hash.from_xml(xml)
      @channel_statistic = @channel_statistic["channelStatistics"]
    end

    def channel_id
      channel_statistic['channelId']
    end
    
    def server_id
      channel_statistic['serverId']
    end
    
    def queued
      channel_statistic['queued'].to_i
    end
    
  end
end
