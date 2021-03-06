module GAnalytics
  module OAuth2
    class Server
      include GAnalytics::OAuth2::Utils

      attr_reader :access_token, :refresh_token, :expires_at, :token_type

      def authorize_url
        "#{GAnalytics.google_auth_url}?client_id=#{GAnalytics.google_client_id}&" \
        "redirect_uri=#{GAnalytics.redirect_uri_for_auth_code}&scope=#{GAnalytics.google_scope_url}&" \
        "access_type=offline&response_type=code".remove_non_ascii
      end

      def request_access_token(code)
        params = "code=#{code}&client_id=#{GAnalytics.google_client_id}&client_secret=#{GAnalytics.google_secret_key}&" \
                 "redirect_uri=#{GAnalytics.redirect_uri_for_auth_code}&grant_type=authorization_code".remove_non_ascii
   
        add_header('Content-Type' => 'application/x-www-form-urlencoded')
        response = http_post(GAnalytics.google_token_url, body: params)

        case response.code
          when 200
            add_header('Authorization' => "OAuth #{response['access_token']}")
            @access_token = response['access_token']
            @refresh_token = response['refresh_token']
            expires_in = response['expires_in']
            @expires_at = Time.now + expires_in if expires_in
            self
          else
            puts "\t-- ERROR -- | #{File.basename __FILE__}:#{__LINE__}: response status code is #{response.code}"
            raise exception("#{File.basename __FILE__}:#{__LINE__}: #{response.parsed_response}")
        end
      end

      def refresh_access_token(refresh_token)
        params = "client_id=#{GAnalytics.google_client_id}&client_secret=#{GAnalytics.google_secret_key}&" \
                 "refresh_token=#{refresh_token}&grant_type=refresh_token".remove_non_ascii
        
        add_header('Content-Type' => 'application/x-www-form-urlencoded')
        response = http_post(GAnalytics.google_token_url, body: params)

        case response.code
          when 200
            add_header('Authorization' => "OAuth #{response['access_token']}")
            @access_token = response['access_token']
            expires_in = response['expires_in']
            @expires_at = Time.now + expires_in if expires_in
            @token_type = response['token_type']
            self
          else
            puts "\t-- ERROR -- | #{File.basename __FILE__}:#{__LINE__}: response status code is #{response.code}"
            raise exception("#{File.basename __FILE__}:#{__LINE__}: #{response.parsed_response}")
        end
      end
    end
  end
end