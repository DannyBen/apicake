module APICake::Mocks
  class HTTPartyResponse
    def request ; :request ; end
    def response; :response; end
    def headers; :headers; end
    def parsed_response; :parsed_response; end
  end
end