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
