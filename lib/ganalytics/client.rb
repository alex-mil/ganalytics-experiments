module GAnalytics
  class Client
    include GAnalytics::OAuth2::Utils
    include GAnalytics::Validator

    def initialize
      @analytics_admin ||= GAnalytics::AnalyticsAdmin.new GAnalytics.account, GAnalytics.property, GAnalytics.view
      @google_oauth ||= GAnalytics::OAuth2::Server.new
    end

    def start_experiment(args = {})
      validate_required_arguments(args, __method__)

      @google_oauth = @google_oauth.request_access_token args[:code]

      url = "https://www.googleapis.com/analytics/v3/management/accounts/#{analytics_admin.account}/" \
            "webproperties/#{analytics_admin.property}/profiles/#{analytics_admin.view}/experiments".remove_non_ascii

      http_response = http_post(url, body: args[:experiment].to_json, headers: headers, timeout: GAnalytics.http_timeout)

      if http_response.ok?
        {
          experiment_id: http_response['id'],
          refresh_token: @google_oauth.refresh_token
        }
      else
        puts "\t-- ERROR -- | #{File.basename __FILE__}:#{__LINE__}: response status code is #{http_response.code}"
        raise exception("#{File.basename __FILE__}:#{__LINE__}: #{http_response.parsed_response}")
      end
    end

    def load_experiment(args = {})
      validate_required_arguments(args, __method__)

      @google_oauth = @google_oauth.refresh_access_token args[:refresh_token]

      url = "https://www.googleapis.com/analytics/v3/management/accounts/#{analytics_admin.account}/" \
            "webproperties/#{analytics_admin.property}/profiles/#{analytics_admin.view}/" \
            "experiments/#{args[:experiment_id]}".remove_non_ascii

      begin
        http_response = http_get(url, headers: headers, timeout: GAnalytics.http_timeout)
        
        if http_response.ok?
          {
            snippet: http_response['snippet'].to_s.html_safe
          }
        else
          puts "\t-- ERROR -- | #{File.basename __FILE__}:#{__LINE__}: response status code is #{http_response.code}"
          raise exception("#{File.basename __FILE__}:#{__LINE__}: #{http_response.parsed_response}")
        end
      rescue Net::ReadTimeout => exp
        puts "\t-- ERROR -- | #{File.basename __FILE__}:#{__LINE__}: #{exp.message}"
        raise exception("#{File.basename __FILE__}:#{__LINE__}: #{exp.message}")
      end
    end

    def stop_experiment(args = {})
      validate_required_arguments(args, __method__)

      @google_oauth = @google_oauth.refresh_access_token args[:refresh_token]

      url = "https://www.googleapis.com/analytics/v3/management/accounts/#{analytics_admin.account}/" \
            "webproperties/#{analytics_admin.property}/profiles/#{analytics_admin.view}/" \
            "experiments/#{args[:experiment_id]}".remove_non_ascii

      begin
        http_response = http_patch(url, body: args[:experiment].to_json, headers: headers, timeout: GAnalytics.http_timeout)
        
        if http_response.ok?
          {
            experiment_id: http_response['id'],
            experiment_name: http_response['name'],
            experiment_status: http_response['status'],
            experiment_ended_at: http_response['endTime'],
            experiment_ending_reason: http_response['reasonExperimentEnded']
          }
        else
          puts "\t-- ERROR -- | #{File.basename __FILE__}:#{__LINE__}: response status code is #{http_response.code}"
          raise exception("#{File.basename __FILE__}:#{__LINE__}: #{http_response.parsed_response}")
        end
      rescue Net::ReadTimeout => exp
        puts "\t-- ERROR -- | #{File.basename __FILE__}:#{__LINE__}: #{exp.message}"
        raise exception("#{File.basename __FILE__}:#{__LINE__}: #{exp.message}")
      end
    end

    private

    attr_reader :analytics_admin

    def headers
      {'Content-Type' => 'application/json', 'Authorization' => "OAuth #{@google_oauth.access_token}"}
    end
  end
end