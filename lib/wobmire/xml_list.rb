module Wobmire
  class XmlList
    Result = ImmutableStruct.new( :success?, :error_messages, :xml_list, :raw )

    # Wobmire::XmlList.fetch(connection, url, identifier)
    #
    # - connection: valid Wobmire::Api Connection (always authenticated)
    # - url: api request
    # - identifier: root node of an single entry
    # 
    # returns result:
    # - result.success?
    # - result.error_messages: array; empty in case of success
    # - result.xml_list: array of single xml entries
    # - result.raw: raw resonse body = plain xml string
    #
    # generic fetch
    def self.fetch(connection, url, identifier)
      # test connection
      unless connection.valid?
        return Result.new(
          success: false, 
          error_messages: ["No valid connection; please connect/authenticate first"],
          xml_list: []
        )
      end
      # fetch body
      response = connection.get(url)
      unless response.success?
        return Result.new(
          success: false, 
          error_messages: ["Fetch xml_list failed for unknown reason"],
          xml_list: [],
          raw: nil
        )
      end
      xml_list = xml_to_list(response.body, identifier)
      raw = response.body
      
      return Result.new(
        success: true, 
        error_messages: [],
        xml_list: xml_list,
        raw: raw
      )
    end

  private
    def self.xml_to_list(text, identifier)
      doc = Nokogiri::XML(text)
      doc.xpath("#{identifier}").map(&:to_s)
    end
  end
end
