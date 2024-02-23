require 'debug' if ENV['DEBUGGER']
require 'sinatra'
require 'yaml'

set :port, 3000
set :bind, '0.0.0.0'

def json(hash)
  content_type :json
  JSON.pretty_generate hash
end

# Handshake
get '/' do
  json mockserver: :online
end

get '/json' do
  json address: '22 Acacia Avenue'
end

get '/html' do
  content_type :html
  '<html>Working</html>'
end

get '/csv' do
  content_type :csv
  <<~CSV
    album,year
    The Number of the Beast,1982
    Powerslave,1984
    Seventh Son of a Seventh Son,1988
    Brave New World,2000
    The Book of Souls,2015
  CSV
end

get '/array' do
  price_data = [
    { date: '2017-01-01', price: 140 },
    { date: '2017-01-02', price: 150 },
  ]

  json price_data: price_data
end

get '/non_array' do
  json first_name: 'Bob', last_name: 'Spunge'
end
