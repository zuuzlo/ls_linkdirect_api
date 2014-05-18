require "recursive_open_struct"

module LsLinkdirectAPI
  class APIResponse
    attr_reader :data, :request

    def initialize(response, response_name)
      @request = response.request
      result = response[ response_name ]
      body = parse(response.body)
      @data = parse(result["return"])
    end

    def all
      while parse(result["return"]) != []
        uri = Addressable::URI.parse(request.uri)
        next_page_response = LsLinkdirectAPI::TextLinks.new.request(uri.origin + uri.path, uri.query_values)
        #@meta = next_page_response.meta
        @data += next_page_response.data
      end
      @data
    end

    private

    def parse(raw_data)
      data = []
      data = [RecursiveOpenStruct.new(raw_data)] if raw_data.is_a?(Hash) # If we got exactly one result, put it in an array.
      raw_data.each { |i| data << RecursiveOpenStruct.new(i) } if raw_data.is_a?(Array)
      data
    end
  end
end