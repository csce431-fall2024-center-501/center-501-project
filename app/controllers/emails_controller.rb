# frozen_string_literal: true

# EmailsController manages various email-sending actions for administrators.
# Inherits from AdminApplicationController, ensuring only admin users have access.
class EmailsController < AdminApplicationController
  # Constant for valid EWB calendar IDs, restricting calendar access to specific calendars.
  EWB_CALENDAR_IDS = ['c_35657eacaf7df0315b9988c9b68e72be62b3d78e730edd6583459300f61320db@group.calendar.google.com'].freeze

  # Sets up the Google Calendar client before any actions are run.
  before_action :initialize_google_calendar_client

  # Displays a form for sending individual emails to selected users.
  #
  # @return [void]
  def individual_email
    @users = User.all
  end

  # Renders the active member email form.
  #
  # @return [void]
  def active_member_email; end

  # Renders the form for emailing both active and inactive members.
  #
  # @return [void]
  def active_inactive_member_email; end

  # Fetches EWB calendars and displays upcoming events in the first calendar.
  #
  # @return [void]
  def calendar_email
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client
    @calendar_list = service.list_calendar_lists.items.select { |calendar| EWB_CALENDAR_IDS.include?(calendar.id) }
    @event_list = service.list_events(@calendar_list.first.id)
  end

  # Sends an individual email to a list of recipients.
  # If the recipient list exceeds 50, emails are sent in batches of 50.
  #
  # @return [void]
  def send_email
    recipients = params[:recipients].split(',')
    subject = params[:subject]
    message = params[:message]
    num_emails = recipients.size

    if num_emails > 50
      while num_emails > 50
        AdminMailer.individual_email(recipients.pop(50), subject, message).deliver_now
        num_emails -= 50
      end
      AdminMailer.individual_email(recipients.pop(num_emails), subject, message).deliver_now
    else
      AdminMailer.individual_email(recipients, subject, message).deliver_now
    end

    redirect_to email_path, notice: 'Email sent successfully.'
  end

  # Sends an email to active members with the provided subject and message.
  #
  # @return [void]
  def send_active_member_email
    subject = params[:subject]
    message = params[:message]
    AdminMailer.active_member_email(subject, message).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
  end

  # Sends an email to both active and inactive members with the provided subject and message.
  #
  # @return [void]
  def send_active_inactive_member_email
    subject = params[:subject]
    message = params[:message]
    AdminMailer.active_inactive_member_email(subject, message).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
  end

  # Fetches events from the EWB calendar and sends them via email.
  #
  # @return [void]
  def send_calendar_email
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client
    @calendar_list = service.list_calendar_lists.items.select { |calendar| EWB_CALENDAR_IDS.include?(calendar.id) }
    @event_list = service.list_events(@calendar_list.first.id)
    AdminMailer.calendar_email(params[:subject], @event_list).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
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
