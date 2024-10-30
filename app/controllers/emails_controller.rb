# frozen_string_literal: true

class EmailsController < AdminApplicationController
  EWB_CALENDAR_IDS = ['c_35657eacaf7df0315b9988c9b68e72be62b3d78e730edd6583459300f61320db@group.calendar.google.com'].freeze
  before_action :initialize_google_calendar_client
  def individual_email
    @users = User.all
  end

  def active_member_email; end

  def active_inactive_member_email; end

  def calendar_email
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client
    @calendar_list = service.list_calendar_lists.items.select { |calendar| EWB_CALENDAR_IDS.include?(calendar.id) }
    @event_list = service.list_events(@calendar_list.first.id)
  end

  def send_email
    recipients = params[:recipients].split(',')
    subject = params[:subject]
    message = params[:message]
    AdminMailer.indiviual_email(recipients, subject, message).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
  end

  def send_active_member_email
    subject = params[:subject]
    message = params[:message]
    AdminMailer.active_member_email(subject, message).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
  end

  def send_active_inactive_member_email
    subject = params[:subject]
    message = params[:message]
    AdminMailer.active_inactive_member_email(subject, message).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
  end

  def send_calendar_email
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client
    @calendar_list = service.list_calendar_lists.items.select { |calendar| EWB_CALENDAR_IDS.include?(calendar.id) }
    @event_list = service.list_events(@calendar_list.first.id)
    AdminMailer.calendar_email(params[:subject], @event_list).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
  end

  private

  def initialize_google_calendar_client
    @client = Signet::OAuth2::Client.new(client_options)
    @client.update!(
      access_token: session[:google_access_token],
      refresh_token: session[:google_refresh_token]
    )
  end

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
