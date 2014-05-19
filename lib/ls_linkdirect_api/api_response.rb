require "recursive_open_struct"

module LsLinkdirectAPI
  class APIResponse
    attr_reader :data, :request

    def initialize(response, response_name, params)
      @request = response.request
      @response_name = response_name
      @params = params
      result = response[ "get#{response_name}Response" ]
      @data = parse(result["return"])
    end

    def all
      get_next_page = true
      while get_next_page
        cls = Object.const_get('LsLinkdirectAPI').const_get(@response_name)
        @params[:page] += 1
        next_page_response = cls.new.get(@params)
        @data += next_page_response.data
        get_next_page = false if next_page_response.data == []
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