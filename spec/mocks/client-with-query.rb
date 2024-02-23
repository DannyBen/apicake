module APICake::Mocks
  class ClientWithQuery < APICake::Base
    base_uri 'http://localhost:3000'

    def default_query
      { apiKey: '123' }
    end
  end
end
