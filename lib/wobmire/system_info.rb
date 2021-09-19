module Wobmire
  class SystemInfo
    attr_reader :xml, :info
    Result = ImmutableStruct.new( :success?, :error_messages, :info )

    ATTRIBUTES = [:jvm_version, :os_name, :os_version, :os_architecture,
                  :db_name, :db_version]

    # Wobmire::SystemInfo.fetch(connection)
    #
    # - connection: valid Wobmire::Api Connection (always authenticated)
    # 
    # returns result:
    # - result.success?
    # - result.error_messages: array; empty in case of success
    # - result.info: system info
    #
    def self.fetch(connection)
      result = Wobmire::XmlList.fetch(connection, "system/info", "//com.mirth.connect.model.SystemInfo")
      unless result.success?
        return Result.new(
          success: result.success?, 
          error_messages: result.error_messages,
          info: nil
        )
      end
      xml = result.xml_list.first
      return Result.new(
        success: true,
        error_messages: [],
        info: Wobmire::SystemInfo.new(xml)
      )
    end

    # Wobmire::SystemInfo.new(xml)
    #
    def initialize(xml)
      @xml = xml
      @info = Hash.from_xml(xml)
      @info = @info["com.mirth.connect.model.SystemInfo"]
    end

    def jvm_version
      info['jvmVersion']
    end

    def os_name
      info['osName']
    end

    def os_version
      info['osVersion']
    end

    def os_architecture
      info['osArchitecture']
    end

    def db_name
      info['dbName']
    end

    def db_version
      info['dbVersion']
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
