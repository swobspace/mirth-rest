module Wobmire
  class ChannelStatus
    attr_reader :xml, :channel_status
    Result = ImmutableStruct.new( :success?, :error_messages, :channel_statuses )

    # Wobmire::Channel.fetch(connection, channel_id = nil)
    #
    # - connection: valid Wobmire::Api Connection (always authenticated)
    # 
    # returns result:
    # - result.success?
    # - result.error_messages: array; empty in case of success
    # - result.channel_statuses: list of Wobmire::Channel instances
    #
    # generic fetch
    def self.fetch(connection, channel_id = nil)
      channel_statuses = []
      if channel_id.blank?
        result = Wobmire::XmlList.fetch(connection, "channels/statuses", "/list/dashboardStatus")
      else
        result = Wobmire::XmlList.fetch(connection, "channels/#{channel_id}/status", "/dashboardStatus")
      end
      unless result.success?
        return Result.new(
          success: result.success?, 
          error_messages: result.error_messages,
          channel_statuses: []
        )
      end
      result.xml_list.each do |xml|
        channel_statuses << Wobmire::ChannelStatus.new(xml)
      end
      return Result.new(
        success: true,
        error_messages: [],
        channel_statuses: channel_statuses
      )
    end

    # Wobmire::ChannelStatus.new(xml)
    #
    def initialize(xml)
      @xml = xml
      @channel_status = Hash.from_xml(xml)
      @channel_status = @channel_status["dashboardStatus"]
    end

    def id
      channel_status['channelId']
    end
    
    def name
      channel_status['name']
    end
    
    def state
      channel_status['state']
    end

    def status_type
      channel_status['statusType']
    end

    def queued
      channel_status['queued']
    end

  end
end
