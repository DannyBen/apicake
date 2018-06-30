require 'apicake'

class Client < APICake::Base
  base_uri 'jsonplaceholder.typicode.com'

  def initialize
    # You can configure caching behavior for the entire class by accessing
    # the Lightly cache object.
    # See: https://github.com/DannyBen/lightly
    cache.enable
    cache.dir = './tmp'
    cache.life = 60 # seconds
  end

end

client = Client.new

p client.cache.dir
# => ./tmp

p client.cache.enabled?
# => true

# You can also configure cache outside of your wrapper class
client.cache.life = 30
client.cache.disable
p client.cache.enabled?
# => false


