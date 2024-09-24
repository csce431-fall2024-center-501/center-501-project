class CalendarController < AuthenticatedApplicationController
  before_action :initialize_google_calendar_client

  def new_event
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    event = Google::Apis::CalendarV3::Event.new(
      summary: params[:event_name],
      start: Google::Apis::CalendarV3::EventDateTime.new(date: params[:start_date]),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: params[:end_date])
    )

    service.insert_event(params[:calendar_id], event)
    redirect_to events_url(calendar_id: params[:calendar_id])
  end

  def calendars
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    @calendar_list = service.list_calendar_lists
  end

  def events
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    @event_list = service.list_events(params[:calendar_id])
  end

  private

  # Initializes the Google client with credentials stored in the session
  def initialize_google_calendar_client
    @client = Signet::OAuth2::Client.new(client_options)
    refresh_token_if_expired!
    @client.update!(
      access_token: session[:google_access_token],
      refresh_token: session[:google_refresh_token]
    )
  end

  # Refreshes the access token if it's expired
  def refresh_token_if_expired!
    if Time.at(session[:google_expires_at]) < Time.now
      response = @client.refresh!
  
      # Update session with new tokens and expiration time
      session[:google_access_token] = response['access_token']
      session[:google_expires_at] = Time.now + response['expires_in'].to_i.seconds
    end
  end

  # OAuth2 client options
  def client_options
    {
      client_id: Rails.application.credentials.google[:client_id],
      client_secret: Rails.application.credentials.google[:client_secret],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR
    }
  end
end
