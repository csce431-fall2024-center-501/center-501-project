# frozen_string_literal: true

class ApplicationController < ActionController::Base
    include Devise::Controllers::Helpers
    before_action :refresh_token_if_needed, if: -> { user_signed_in? }
    
    private
    # Refreshes token if needed
    def refresh_token_if_needed
        begin
            refresh_token_if_expired!
        rescue Signet::AuthorizationError => e
            flash[:alert] = "Google Calendar authorization error - please reauthenticate"
            sign_out
        end
    end

    # Refreshes the access token if it's expired
    def refresh_token_if_expired!
        return unless Time.at(session[:google_expires_at]) < Time.now
        token_url = 'https://oauth2.googleapis.com/token'

        # Prepare the request parameters
        params = {
            client_id: Rails.application.credentials.google[:client_id],
            client_secret: Rails.application.credentials.google[:client_secret],
            refresh_token: session[:google_refresh_token],
            grant_type: 'refresh_token'
        }

        # Make the HTTP POST request
        uri = URI.parse(token_url)
        response = Net::HTTP.post_form(uri, params)

        # Parse and handle the response
        if response.is_a?(Net::HTTPSuccess)
            response_body = JSON.parse(response.body)
            session[:google_access_token] = response_body['access_token']
            session[:google_expires_at] = Time.now + response_body['expires_in'].to_i.seconds
        else
            puts "Error: #{response.code} - #{response.message}"
            nil
        end
    end
end
