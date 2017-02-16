require 'apicake'

class Client < APICake::Base
  base_uri 'jsonplaceholder.typicode.com'
end

client = Client.new

p client.users.count
# => 10

p client.users 1
# => {"id"=>1, "name"=>"Leanne Graham", ...}

p client.last_url
# => http://jsonplaceholder.typicode.com/users/1

p client.comments postId: 1
p client.last_url
# => http://jsonplaceholder.typicode.com/comments?postId=1
