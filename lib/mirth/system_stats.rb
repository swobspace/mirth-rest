module Mirth
  class SystemStats
    attr_reader :xml, :stats
    Result = ImmutableStruct.new( :success?, :error_messages, :stats )

    ATTRIBUTES = [
      :timestamp, 
      :timezone, 
      :cpu_usage_pct, 
      :allocated_memory_bytes,
      :free_memory_bytes,
      :max_memory_bytes,
      :disk_free_bytes,
      :disk_total_bytes
    ]

    # Mirth::SystemStats.fetch(connection)
    #
    # - connection: valid Mirth::Api Connection (always authenticated)
    # 
    # returns result:
    # - result.success?
    # - result.error_messages: array; empty in case of success
    # - result.stats: system stats
    #
    def self.fetch(connection)
      result = Mirth::XmlList.fetch(connection, "system/stats", "com.mirth.connect.model.SystemStats")
      unless result.success?
        return Result.new(
          success: result.success?, 
          error_messages: result.error_messages,
          stats: nil
        )
      end
      xml = result.xml_list.first
      return Result.new(
        success: true,
        error_messages: [],
        stats: Mirth::SystemStats.new(xml)
      )
    end

    # Mirth::SystemInfo.new(xml)
    #
    def initialize(xml)
      @xml = xml
      @stats = Hash.from_xml(xml)
      @stats = @stats["com.mirth.connect.model.SystemStats"]
    end

    def timestamp
      stats['timestamp']['time']
    end
    def timezone
      stats['timestamp']['timezone']
    end

    def cpu_usage_pct
      stats['cpuUsagePct']
    end

    def allocated_memory_bytes
      stats['allocatedMemoryBytes']
    end

    def free_memory_bytes
      stats['freeMemoryBytes']
    end

    def max_memory_bytes
      stats['maxMemoryBytes']
    end

    def disk_free_bytes
      stats['diskFreeBytes']
    end

    def disk_total_bytes
      stats['diskTotalBytes']
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
