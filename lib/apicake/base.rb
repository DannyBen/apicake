require 'httparty'
require 'lightly'

module APICake
  class Base
    include HTTParty

    def method_missing(method_sym, *arguments, &_block)
      get "/#{method_sym}", *arguments
    end

    def cache
      @cache ||= Lightly.new
    end

    protected

    # Overridables
    def default_params; {}; end
    def default_query;  {}; end

    def get path, extra=nil, params={}
      key = "#{path}+#{extra}+#{params}"

      cache.get key do
        get!(path, extra, params)
      end
    end

    def get! path, extra=nil, params={}
      if extra.is_a?(Hash) and params.empty?
        params = extra
        extra = nil
      end

      path = "#{path}/#{extra}" if extra
      params[:query] = default_query.merge params
      params = default_params.merge params

      response = self.class.get path, params
      APICake::Response.new response
    end
  end
end