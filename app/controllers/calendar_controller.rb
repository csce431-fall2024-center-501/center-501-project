# frozen_string_literal: true

class CalendarController < OfficerApplicationController
  EWB_CALENDAR_IDS = ['c_35657eacaf7df0315b9988c9b68e72be62b3d78e730edd6583459300f61320db@group.calendar.google.com'].freeze

  before_action :initialize_google_calendar_client

  def new_event
    # Redirect and halt execution if calendar_id is not valid
    unless EWB_CALENDAR_IDS.include?(params[:calendar_id])
      flash[:alert] = 'Invalid calendar ID - only EWB calendars are supported.'
      redirect_to calendars_path and return
    end

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    start_date_time = begin
      params[:start_datetime].to_datetime.rfc3339
    rescue StandardError
      nil
    end
    end_date_time = begin
      params[:end_datetime].to_datetime.rfc3339
    rescue StandardError
      nil
    end

    start_date = begin
      params[:start_date]
    rescue StandardError
      nil
    end
    end_date = begin
      params[:end_date]
    rescue StandardError
      nil
    end

    event = Google::Apis::CalendarV3::Event.new(
      summary: params[:event_name],
      start: if start_date_time
               Google::Apis::CalendarV3::EventDateTime.new(
                 date_time: (start_date_time.to_time + 5.hours).rfc3339
               )
             else
               Google::Apis::CalendarV3::EventDateTime.new(
                 date: start_date
               )
             end,
      end: if end_date_time
             Google::Apis::CalendarV3::EventDateTime.new(
               date_time: (end_date_time.to_time + 5.hours).rfc3339
             )
           else
             Google::Apis::CalendarV3::EventDateTime.new(
               date: end_date
             )
           end
    )

    service.insert_event(params[:calendar_id], event)
    redirect_to events_url(calendar_id: params[:calendar_id])
  end

  def calendars
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client
    @calendar_list = service.list_calendar_lists.items.select { |calendar| EWB_CALENDAR_IDS.include?(calendar.id) }
    redirect_to events_url(calendar_id: @calendar_list.first.id) if @calendar_list.length == 1
  end

  def events
    unless EWB_CALENDAR_IDS.include?(params[:calendar_id])
      flash[:alert] = 'Invalid calendar ID - only EWB calendars are supported.'
      redirect_to calendars_path and return
    end

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    @event_list = service.list_events(params[:calendar_id])
    @calendar_id = params[:calendar_id]
  end

  private

  # Initializes the Google client with credentials stored in the session
  def initialize_google_calendar_client
    @client = Signet::OAuth2::Client.new(client_options)
    @client.update!(
      access_token: session[:google_access_token],
      refresh_token: session[:google_refresh_token]
    )
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
