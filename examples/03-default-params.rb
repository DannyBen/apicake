require 'apicake'

class Client < APICake::Base
  base_uri 'jsonplaceholder.typicode.com'

  attr_reader :username, :password

  def initialize(username, password)
    @username, @password = username, password
  end

  # By defining a #default_params method, you can tell APICake to merge
  # these parameters into the HTTParty Get request. For example, this 
  # method adds basic authentication credentials to the request.
  def default_params
    { basic_auth: { username: username, password: password } }
  end

end

client = Client.new 'me', 'secret'
