require 'httparty'
require 'lightly'

module APICake
  # To create your API wrapper, make a class that inherit from this class.
  # 
  # This class includes the HTTParty module, and the only requirement, 
  # is that you call +base_uri+ to define the base URI of the API.
  #
  # === Example
  # 
  #   class Client < APICake::Base
  #     base_uri: 'http://some.api.com/v3'
  #   end
  #
  class Base
    include HTTParty

    # Holds the last {Payload} object that was obtained by the last call to
    # {#get}, {#get!}, {#get_csv} or {#save_csv}
    #
    # === Example
    # 
    #   client = Client.new
    #   client.some_path, param: value
    #   p client.last_payload
    #   # => a Payload object
    #
    attr_reader :last_payload
    

    # Holds the last URL that was downloaded by the last call to
    # {#get}, {#get!}, {#get_csv} or {#save_csv}.
    #
    # === Example
    # 
    #   client = Client.new
    #   client.some_path, param: value
    #   p client.last_url
    #   # => "http://some.api.com/v3/some_path?param=value"
    #
    attr_reader :last_url

    # Any undefined method call will be delegated to the {#get} method.
    # 
    # === Example
    # 
    # This:
    #
    #   client = Client.new
    #   client.path 'optional_sub_path', optional_param: value, optional_param: value 
    #
    # Is equivalent to this:
    #  
    #   client.get 'path/optional_sub_path', optional_param: value, optional_param: value 
    #
    def method_missing(method_sym, *arguments, &_block)
      get "/#{method_sym}", *arguments
    end

    # This is the {https://github.com/DannyBen/lightly Lightly} cache object. 
    # You can access or modify cache settings with this object.
    #
    # === Example
    # 
    #   client = Client.new
    #   client.cache.life = 3600
    #   client.cache.dir = './cache'
    #   client.cache.disable
    #   client.cache.enable
    #
    def cache
      @cache ||= Lightly.new
    end

    # Override this method in order to merge parameters into the query 
    # string before each call.
    #
    # === Example
    #
    #   class Client < APICake::Base
    #     base_uri: 'http://some.api.com/v3'      
    #  
    #     def initialize(api_key)
    #       @api_key = api_key
    #     end
    #  
    #     def default_query
    #       { api_key: @api_key }
    #     end
    #   end
    #  
    #   client = Client.new 'secret'
    #   client.some_path param: 'value'
    #   p client.last_url
    #   # => "http://some.api.com/v3/some_path?api_key=secret&param=value"
    #
    def default_query;  {}; end

    # Override this method in order to merge parameters into the HTTParty
    # get request. 
    #
    # === Eexample
    #
    #   class Client < APICake::Base
    #     base_uri: 'http://some.api.com/v3'      
    #  
    #     def initialize(user, pass)
    #       @user, @pass = user, pass
    #     end
    #  
    #     def default_params
    #       { basic_auth: { username: user, password: pass }
    #     end
    #   end
    #
    # @see http://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/ClassMethods HTTParty Class Methods documentation
    #
    def default_params; {}; end

    # Make a request or get it from cache, and return the parsed response.
    #
    # This is the same as calling {#get!} and gettings its +parsed_response+
    # value.
    #
    # Normally, you should not have the need to use this method, since all
    # unhandled method calls are handled by {#method_missing} and are 
    # delegated here.
    #
    # === Example
    #
    #   client = Client.new
    #   client.get 'path/to/resource', param: value, param: value
    #
    def get(path, extra=nil, params={})
      get!(path, extra, params).parsed_response
    end

    # Make a request or get it from cache, and return the entire {Payload} 
    # object.
    def get!(path, extra=nil, params={})
      path, extra, params = normalize path, extra, params
      key = cache_key path, extra, params

      @last_payload = cache.get key do
        http_get(path, extra, params)
      end

      @last_url = @last_payload.request.last_uri.to_s
      @last_payload
    end

    # A shortcut to just get the constructed URL of the request.
    # Note that this call will make the HTTP request (unless it is already 
    # cached).
    # 
    # If you have already made the request, you can use {#last_url} instead.
    def url(path, extra=nil, params={})
      get! path, extra, params
      last_url
    end

    # Save the response body to a file
    #
    # === Example
    #
    #   client = Client.new
    #   client.save 'out.json', 'some/to/resource', param: value
    #
    def save(filename, path, params={})
      payload = get! path, nil, params
      File.write filename, payload.response.body
    end

    # This method uses {#get!} to download and parse the content. It then
    # makes the best effort to convert the right part of the data to a 
    # CSV string.
    #
    # You can override this method if you wish to provide a different 
    # behavior.
    #
    def get_csv(*args)
      payload = get!(*args)

      if payload.response.code != '200'
        raise BadResponse, "#{payload.response.code} #{payload.response.msg}"
      end

      response = payload.parsed_response

      unless response.is_a? Hash
        raise BadResponse, "Cannot parse response"
      end
      
      data = csv_node response

      header = data.first.keys
      result = CSV.generate do |csv|
        csv << header
        data.each { |row| csv << row.values }
      end

      result
    end

    # Same as {#save}, only use the output of {#get_csv} instead of the 
    # response body.
    def save_csv(file, *args)
      File.write file, get_csv(*args)
    end

    # Determins which part of the data is best suited to be displayed 
    # as CSV. 
    #
    # - If the response contains one or more arrays, the first array will
    #   be the CSV output
    # - Otherwise, if the response was parsed to a ruby object, the response
    #   itself will be used as a single-row CSV output.
    #
    # Override this if you want to have a different decision process.
    #
    def csv_node(data)
      arrays = data.keys.select { |key| data[key].is_a? Array }
      arrays.empty? ? [data] : data[arrays.first]
    end

    private

    # Make a call with HTTParty and return a payload object.
    def http_get(path, extra=nil, params={})
      payload = self.class.get path, params
      APICake::Payload.new payload
    end

    # Normalize the three input parameters
    def normalize(path, extra=nil, params={})
      if extra.is_a?(Hash) and params.empty?
        params = extra
        extra = nil
      end

      path = "#{path}/#{extra}" if extra
      path = "/#{path}" unless path[0] == '/'

      query = default_query.merge params

      params[:query] = query unless query.empty?
      params = default_params.merge params

      [path, extra, params]
    end

    # The key for the cache object
    def cache_key(path, extra, params)
      "#{self.class.base_uri}+#{path}+#{extra}+#{params}"
    end
  end
end
