class MailController < ApplicationController
  before_action :initialize_google_gmail_client, only: [:send_email]

  def send_email
    message = Google::Apis::GmailV1::Message.new(raw: Base64.urlsafe_encode64("To: #{params[:to]}\r\nSubject: #{params[:subject]}\r\n\r\n#{params[:body]}"))
    @gmail_service.send_user_message('me', message)
    render json: { status: 'Email sent successfully' }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def mail
    render
  end

  private

  # Initializes the Google client with credentials stored in the session
  def initialize_google_gmail_client
    @client = Signet::OAuth2::Client.new(client_options)
    refresh_token_if_expired!
    @client.update!(
      access_token: session[:google_access_token],
      refresh_token: session[:google_refresh_token]
    )
    @gmail_service = Google::Apis::GmailV1::GmailService.new
    @gmail_service.authorization = @client
  end

  # Refreshes the access token if it's expired
  def refresh_token_if_expired!
    return unless Time.at(session[:google_expires_at]) < Time.now

    response = @client.refresh!

    # Update session with new tokens and expiration time
    session[:google_access_token] = response['access_token']
    session[:google_expires_at] = Time.now + response['expires_in'].to_i.seconds
  end

  # OAuth2 client options
  def client_options
    {
      client_id: Rails.application.credentials.google[:client_id],
      client_secret: Rails.application.credentials.google[:client_secret],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::GmailV1::AUTH_GMAIL_SEND
    }
  end
end
