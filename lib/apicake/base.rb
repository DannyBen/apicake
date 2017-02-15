require 'httparty'
require 'lightly'

module APICake
  class Base
    include HTTParty

    attr_reader :last_payload

    def method_missing(method_sym, *arguments, &_block)
      get "/#{method_sym}", *arguments
    end

    def cache
      @cache ||= Lightly.new
    end

    # Overridables
    def default_params; {}; end
    def default_query;  {}; end

    def get(path, extra=nil, params={})
      get!(path, extra, params).parsed_response
    end

    def get!(path, extra=nil, params={})
      key = "#{self.class.base_uri}+#{path}+#{extra}+#{params}"

      @last_payload = cache.get key do
        http_get(path, extra, params)
      end
    end

    def url(path, extra=nil, params={})
      payload = get! path, extra, params
      payload.request.last_uri.to_s
    end

    def save(filename, path, params={})
      payload = get! path, nil, params
      File.write filename, payload.response.body
    end

    private

    def http_get(path, extra=nil, params={})
      if extra.is_a?(Hash) and params.empty?
        params = extra
        extra = nil
      end

      path = "#{path}/#{extra}" if extra
      path = "/#{path}" unless path[0] == '/'

      params[:query] = default_query.merge params
      params = default_params.merge params

      payload = self.class.get path, params
      APICake::Payload.new payload
    end
  end
end
