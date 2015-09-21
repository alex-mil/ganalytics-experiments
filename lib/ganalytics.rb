require 'httparty'

require 'ganalytics/extensions/string'

require 'ganalytics/oauth2/utils'
require 'ganalytics/oauth2/server'
require 'ganalytics/oauth2/request'
require 'ganalytics/oauth2/error'

require 'ganalytics/validator'
require 'ganalytics/client'
require 'ganalytics/analytics_admin'

module GAnalytics
  extend self

  def client
    GAnalytics::Client.new
  end

  def version
    '1.1.2'
  end

  def setup
    yield self
  end

  def google_client_id
    @@google_client_id
  end

  def google_client_id=(value)
    @@google_client_id = value
  end

  def google_secret_key
    @@google_secret_key
  end

  def google_secret_key=(value)
    @@google_secret_key = value
  end

  def redirect_uri_for_auth_code
    @@redirect_uri_for_auth_code
  end

  def redirect_uri_for_auth_code=(value)
    @@redirect_uri_for_auth_code = value
  end

  def google_scope_url
    @@google_scope_url
  end

  def google_scope_url=(value)
    @@google_scope_url = value
  end

  def google_auth_url
    @@google_auth_url
  end

  def google_auth_url=(value)
    @@google_auth_url = value
  end

  def google_token_url
    @@google_token_url
  end

  def google_token_url=(value)
    @@google_token_url = value
  end

  def http_timeout
    @@http_timeout
  end

  def http_timeout=(value)
    @@http_timeout = value
  end

  def account
    @@account
  end

  def account=(value)
    @@account = value
  end

  def property
    @@property
  end

  def property=(value)
    @@property = value
  end

  def view
    @@view
  end

  def view=(value)
    @@view = value
  end

  module OAuth2
    extend self

    def authorize_url
      @@auth_url ||= GAnalytics::OAuth2::Server.new.authorize_url
    end
  end
end