module GAnalytics
  module OAuth2
    module Utils
      def exception(message)
        GAnalytics::OAuth2::Error.new message
      end

      def add_header(item)
        GAnalytics::OAuth2::Request.headers.merge! item
      end

      def http_post(url, configs = {})
        GAnalytics::OAuth2::Request.post(url, configs)
      end

      def http_get(url, configs = {})
        GAnalytics::OAuth2::Request.get(url, configs)
      end

      def http_put(url, configs = {})
        GAnalytics::OAuth2::Request.put(url, configs)
      end

      def http_patch(url, configs = {})
        GAnalytics::OAuth2::Request.patch(url, configs)
      end
    end
  end
end