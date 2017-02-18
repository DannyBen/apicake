require 'httparty'
require 'lightly'

module APICake
  class Base
    include HTTParty

    attr_reader :last_payload, :last_url

    # Any undefined method will be delegated to the #get method
    def method_missing(method_sym, *arguments, &_block)
      get "/#{method_sym}", *arguments
    end

    # This is the Lightly cache object. You can access or modify cache 
    # settings with this object.
    def cache
      @cache ||= Lightly.new
    end

    # Override this method in order to merge parameters into the query 
    # string.
    def default_query;  {}; end

    # Override this method in order to merge parameters into the HTTParty
    # get request. 
    # See http://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/ClassMethods
    def default_params; {}; end

    # Make a request or get it from cache, and return the parsed response.
    def get(path, extra=nil, params={})
      get!(path, extra, params).parsed_response
    end

    # Make a request or get it from cache, and return the entire payload 
    # objkect.
    def get!(path, extra=nil, params={})
      path, extra, params = normalize path, extra, params
      key = cache_key path, extra, params

      @last_payload = cache.get key do
        http_get(path, extra, params)
      end

      @last_url = @last_payload.request.last_uri.to_s
      @last_payload
    end

    # A shortcut to just get the constructed URL. Note that this call will
    # make the request (unless it is already cached).
    def url(path, extra=nil, params={})
      get! path, extra, params
      last_url
    end

    # Save the response body to a file
    def save(filename, path, params={})
      payload = get! path, nil, params
      File.write filename, payload.response.body
    end

    # Forwards all arguments to #get! and converts its parsed response to 
    # CSV. If the response contains one or more arrays, the first array will
    # be the CSV output, otherwise, the response itself will be used.
    # You can override this method if you wish to provide a different 
    # behavior.
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

    # Send a request, convert it to CSV and save it to a file.
    def save_csv(file, *args)
      File.write file, get_csv(*args)
    end

    # Determins which part of the data is best suited to be displayed 
    # as CSV. 
    # - In case there is an array in the data, it will be returned.
    # - Otherwise, we will use the entire response as a single row CSV.
    # Override this if you want to have a different decision process.
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
