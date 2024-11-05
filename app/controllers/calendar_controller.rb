# frozen_string_literal: true

# CalendarController provides actions for managing Google Calendar events
# related to Engineers Without Borders (EWB) calendars. Inherits access control
# from OfficerApplicationController, ensuring only users with officer-level
# permissions can access these actions.
class CalendarController < OfficerApplicationController
  # Constant for valid EWB calendar IDs, used to limit access to specific
  # calendars only.
  EWB_CALENDAR_IDS = ['c_35657eacaf7df0315b9988c9b68e72be62b3d78e730edd6583459300f61320db@group.calendar.google.com'].freeze

  # Sets up the Google Calendar client before any actions are run.
  before_action :initialize_google_calendar_client

  # Creates a new event in the specified EWB calendar.
  # Redirects with an alert if the calendar ID is invalid.
  #
  # @return [void]
  def new_event
    unless EWB_CALENDAR_IDS.include?(params[:calendar_id])
      flash[:alert] = 'Invalid calendar ID - only EWB calendars are supported.'
      redirect_to calendars_path and return
    end

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    # Sets event start and end times
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

    # Creates the event with the provided parameters
    event = Google::Apis::CalendarV3::Event.new(
      summary: params[:event_name],
      start: start_date_time ? Google::Apis::CalendarV3::EventDateTime.new(date_time: (start_date_time.to_time + 6.hours).rfc3339) : Google::Apis::CalendarV3::EventDateTime.new(date: start_date),
      end: end_date_time ? Google::Apis::CalendarV3::EventDateTime.new(date_time: (end_date_time.to_time + 6.hours).rfc3339) : Google::Apis::CalendarV3::EventDateTime.new(date: end_date),
      description: params[:description]
    )

    service.insert_event(params[:calendar_id], event)
    redirect_to events_url(calendar_id: params[:calendar_id])
  end

  # Lists calendars available to the user, filtering to show only EWB calendars.
  #
  # @return [void]
  def calendars
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client
    @calendar_list = service.list_calendar_lists.items.select { |calendar| EWB_CALENDAR_IDS.include?(calendar.id) }
    redirect_to events_url(calendar_id: @calendar_list.first.id) if @calendar_list.length == 1
  end

  # Displays all events for a specified EWB calendar.
  #
  # @return [void]
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

  # Displays details for a single event in a specified EWB calendar.
  #
  # @return [void]
  def event
    unless EWB_CALENDAR_IDS.include?(params[:calendar_id])
      flash[:alert] = 'Invalid calendar ID - only EWB calendars are supported.'
      redirect_to calendars_path and return
    end

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client
    @event = service.get_event(params[:calendar_id], params[:event_id])
    @calendar_id = params[:calendar_id]
  end

  # Deletes an event from a specified EWB calendar.
  #
  # @return [void]
  def delete_event
    unless EWB_CALENDAR_IDS.include?(params[:calendar_id])
      flash[:alert] = 'Invalid calendar ID - only EWB calendars are supported.'
      redirect_to calendars_path and return
    end

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client
    service.delete_event(params[:calendar_id], params[:event_id])
    redirect_to events_url(calendar_id: params[:calendar_id])
  end

  # Displays edit form for a specific event in a specified EWB calendar.
  #
  # @return [void]
  def edit_event
    unless EWB_CALENDAR_IDS.include?(params[:calendar_id])
      flash[:alert] = 'Invalid calendar ID - only EWB calendars are supported.'
      redirect_to calendars_path and return
    end

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client
    @event = service.get_event(params[:calendar_id], params[:event_id])
    @calendar_id = params[:calendar_id]
  end

  # Updates an existing event in a specified EWB calendar.
  #
  # @return [void]
  def update_event
    unless EWB_CALENDAR_IDS.include?(params[:calendar_id])
      flash[:alert] = 'Invalid calendar ID - only EWB calendars are supported.'
      redirect_to calendars_path and return
    end

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    # Sets updated start and end times
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

    # Updates the event with new parameters
    event = Google::Apis::CalendarV3::Event.new(
      summary: params[:event_name],
      start: start_date_time ? Google::Apis::CalendarV3::EventDateTime.new(date_time: (start_date_time.to_time + 6.hours).rfc3339) : Google::Apis::CalendarV3::EventDateTime.new(date: start_date),
      end: end_date_time ? Google::Apis::CalendarV3::EventDateTime.new(date_time: (end_date_time.to_time + 6.hours).rfc3339) : Google::Apis::CalendarV3::EventDateTime.new(date: end_date),
      description: params[:description]
    )

    service.update_event(params[:calendar_id], params[:event_id], event)
    redirect_to event_url(calendar_id: params[:calendar_id], event_id: params[:event_id])
  end

  private

  # Initializes the Google Calendar client using stored credentials.
  #
  # @return [void]
  def initialize_google_calendar_client
    @client = Signet::OAuth2::Client.new(client_options)
    @client.update!(
      access_token: session[:google_access_token],
      refresh_token: session[:google_refresh_token]
    )
  end

  # Provides OAuth2 client options for Google Calendar API integration.
  #
  # @return [Hash] Options required for Google OAuth2 client
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
