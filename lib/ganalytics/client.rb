module GAnalytics
  class Client
    include GAnalytics::OAuth2::Utils

    attr_accessor :analytics_admin

    def initialize
      @analytics_admin ||= GAnalytics::AnalyticsAdmin.new
      @google_oauth ||= GAnalytics::OAuth2::Server.new
    end

    def start_experiment(args = {})
      @google_oauth = @google_oauth.request_access_token args[:code]

      url = "https://www.googleapis.com/analytics/v3/management/accounts/#{analytics_admin.account}/" \
            "webproperties/#{analytics_admin.property}/profiles/#{analytics_admin.view}/experiments"

      http_response = HTTParty.post(url, body: args[:experiment].to_json, headers: headers, timeout: GAnalytics.http_timeout)

      if http_response.ok?
        {
          experiment_id: http_response['id'],
          refresh_token: @google_oauth.refresh_token
        }
      else
        puts "\t-- ERROR -- : GAnalytics::Client = #{http_response.parsed_response}"
        raise exception("GAnalytics::Client = #{response.code} #{http_response.parsed_response}")
      end
    end

    def load_experiment(args = {})
      @google_oauth = @google_oauth.refresh_access_token args[:refresh_token]

      url = "https://www.googleapis.com/analytics/v3/management/accounts/#{analytics_admin.account}/" \
            "webproperties/#{analytics_admin.property}/profiles/#{analytics_admin.view}/" \
            "experiments/#{args[:experiment_id]}"

      begin
        http_response = HTTParty.get(url, headers: headers, timeout: GAnalytics.http_timeout)
        
        if http_response.ok?
          {
            snippet: http_response['snippet'].to_s.html_safe
          }
        else
          puts "\t-- ERROR -- : GAnalytics::Client = #{http_response.parsed_response}"
          raise exception("GAnalytics::Client = #{response.code} #{http_response.parsed_response}")
        end
      rescue Net::ReadTimeout => exp
        puts "\t-- ERROR -- : GAnalytics::Client = #{exp.message}"
        raise exception("GAnalytics::Client = #{exp.message}")
      end
    end

    private

    def headers
      {'Content-Type' => 'application/json', 'Authorization' => "OAuth #{@google_oauth.access_token}"}
    end
  end
end