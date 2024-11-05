# frozen_string_literal: true

# ApplicationController serves as the base controller for all other controllers,
# providing shared functionality, including user authentication checks and
# token management for Google Calendar API integration.
class ApplicationController < ActionController::Base
  # Includes Devise helper methods for user authentication management
  include Devise::Controllers::Helpers

  # Sets up a before action to refresh the Google access token if needed.
  # Only runs if the user is signed in.
  before_action :refresh_token_if_needed, if: -> { user_signed_in? }
  
  private

  # Refreshes the Google Calendar API access token if it's expired.
  # Triggers reauthentication if token refresh fails.
  #
  # @raise [Signet::AuthorizationError] if the authorization process fails,
  #        prompting a user sign-out and an alert to reauthenticate.
  # @return [void]
  def refresh_token_if_needed
    begin
      refresh_token_if_expired!
    rescue Signet::AuthorizationError => e
      flash[:alert] = "Google Calendar authorization error - please reauthenticate"
      sign_out
    end
  end

  # Checks the expiration time of the Google access token.
  # If expired, makes a request to refresh the token using Google's OAuth endpoint.
  #
  # Uses the refresh token stored in session to request a new access token.
  # Updates the session with the new access token and its expiration time.
  #
  # @return [void]
  def refresh_token_if_expired!
    return unless Time.at(session[:google_expires_at]) < Time.now
    token_url = 'https://oauth2.googleapis.com/token'

    # Parameters for the token refresh request
    params = {
      client_id: Rails.application.credentials.google[:client_id],
      client_secret: Rails.application.credentials.google[:client_secret],
      refresh_token: session[:google_refresh_token],
      grant_type: 'refresh_token'
    }

    # Executes the HTTP POST request to refresh the access token
    uri = URI.parse(token_url)
    response = Net::HTTP.post_form(uri, params)

    # Parses the response and updates session values if successful
    if response.is_a?(Net::HTTPSuccess)
      response_body = JSON.parse(response.body)
      session[:google_access_token] = response_body['access_token']
      session[:google_expires_at] = (Time.now + response_body['expires_in'].to_i).to_i
    else
      puts "Error: #{response.code} - #{response.message}"
      nil
    end
  end

  # Checks if the current user is an admin. If not, it redirects them
  # to the root path with an alert message.
  #
  # @return [Boolean] true if the user is an admin, false otherwise
  def require_admin
    unless current_user && current_user&.admin?
      flash[:alert] = 'You must be an admin to access this section.'
      redirect_to root_path
      return false
    end
    true
  end

  # Checks if the current user has officer-level permissions or higher.
  # If not, redirects to the root path with an alert message.
  #
  # @return [Boolean] true if the user is at least an officer, false otherwise
  def require_officer
    unless current_user && current_user&.atleast_officer?
      flash[:alert] = 'You must be an officer to access this section.'
      redirect_to root_path
      return false
    end
    true
  end
end
