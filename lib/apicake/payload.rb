module APICake
  class Payload
    attr_reader :request, :response, :headers, :parsed_response

    def initialize(response)
      @request         = response.request
      @headers         = response.headers
      @response        = response.response
      @parsed_response = response.parsed_response
    end

    def to_h
      { request: request, response: response, headers: headers, 
        parsed_response: parsed_response }
    end

    def to_s
      parsed_response.to_s
    end
  end
end
