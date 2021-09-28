module APICake::Mocks
  class ClientWithQuery < APICake::Base
    base_uri "http://www.mocky.io/v2"

    def default_query
      { apiKey: "123" } 
    end
  end
end
