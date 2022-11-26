require 'apicake'

class Client < APICake::Base
  base_uri 'jsonplaceholder.typicode.com'

  attr_reader :api_key

  def initialize(api_key)
    @api_key = api_key
  end

  # By defining a #default_query method, you can tell APICake to merge these
  # parameters into each request. This is suitable for providing an API key
  # or any other "sticky" parameter, like requested format.
  def default_query
    { api_key: api_key, format: :json }
  end
end

client = Client.new 'mykey'

client.users
p client.last_url
# => http://jsonplaceholder.typicode.com/users?api_key=mykey&format=json
