require 'ganalytics'

GAnalytics.setup do |config|
  config.google_client_id  = ENV['GOOGLE_OAUTH2_CLIENT_ID'] || ''
  config.google_secret_key = ENV['GOOGLE_OAUTH2_CLIENT_SECRET'] || ''
  
  # enter a full URL of your site to redirect back to after obtaining Google auth code
  case Rails.env
    when 'production' then
      config.redirect_uri_for_auth_code = ''
    when 'staging' then
      config.redirect_uri_for_auth_code = ''
    else
      config.redirect_uri_for_auth_code = ''
  end
  
  config.google_scope_url = 'https://www.googleapis.com/auth/analytics'
  config.google_auth_url  = 'https://accounts.google.com/o/oauth2/auth'
  config.google_token_url = 'https://www.googleapis.com/oauth2/v3/token'
  config.account          = ENV['GA_ACCOUNT'] || ''
  config.property         = ENV['GA_WEBPROPERTY'] || ''
  config.view             = ENV['GA_VIEW'] || ''
  config.http_timeout     = 5
end