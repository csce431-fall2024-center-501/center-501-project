# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CalendarController', type: :request do
  let(:valid_calendar_id) do
    'c_35657eacaf7df0315b9988c9b68e72be62b3d78e730edd6583459300f61320db@group.calendar.google.com'
  end
  let(:invalid_calendar_id) { 'invalid_calendar_id' }

  include TestAttributes

  before do
    # Mock session data for authentication and tokens
    allow_any_instance_of(CalendarController).to receive(:session).and_return({
                                                                                google_access_token: 'valid_access_token',
                                                                                google_refresh_token: 'valid_refresh_token',
                                                                                google_expires_at: Time.now + 1.hour
                                                                              })
  end

  # Mock the Google API client and service
  let(:google_client) { instance_double(Signet::OAuth2::Client) }
  let(:calendar_service) { instance_double(Google::Apis::CalendarV3::CalendarService) }

  before do
    # Stub the initialization of Signet::OAuth2::Client
    allow(Signet::OAuth2::Client).to receive(:new).and_return(google_client)
    allow(google_client).to receive(:update!)
    allow(google_client).to receive(:refresh!).and_return('access_token' => 'new_access_token', 'expires_in' => 3600)

    # Stub the initialization of Google Calendar service
    allow(Google::Apis::CalendarV3::CalendarService).to receive(:new).and_return(calendar_service)
    allow(calendar_service).to receive(:authorization=).with(google_client)
  end

  describe 'POST /new_event' do
    context 'with valid parameters and logged in officer account' do
      let(:event_params) do
        {
          event_name: 'Test Event',
          start_date: '2023-01-01',
          end_date: '2023-01-02'
        }
      end

      before do
        allow(calendar_service).to receive(:insert_event).and_return(true)
        sign_in User.create! valid_officer_attributes
      end

      it 'creates a new event and redirects to events_url' do
        post "/events/#{valid_calendar_id}", params: event_params

        expect(calendar_service).to have_received(:insert_event).with(
          valid_calendar_id,
          have_attributes(
            summary: 'Test Event',
            start: have_attributes(date: '2023-01-01'),
            end: have_attributes(date: '2023-01-02')
          )
        )
        expect(response).to redirect_to(events_url(calendar_id: valid_calendar_id))
      end
    end

    context 'with invalid calendar_id but signed in officer account' do
      let(:event_params) do
        {
          event_name: 'Test Event',
          start_date: '2023-01-01',
          end_date: '2023-01-02'
        }
      end

      before do
        sign_in User.create! valid_officer_attributes
      end

      it 'redirects to calendars_path' do
        post "/events/#{invalid_calendar_id}", params: event_params

        expect(response).to redirect_to(calendars_path)
        expect(flash[:alert]).to eq('Invalid calendar ID - only EWB calendars are supported.')
      end
    end
  end

  describe 'GET /calendars' do
    context 'with a logged in officer account' do
      let(:calendar_list_response) do
        double('CalendarList', items: [
                double('Calendar', id: valid_calendar_id, summary: 'Test Calendar12345'),
                double('Calendar', id: 'other_calendar_id', summary: 'Other Calendar67890')
              ])
      end

      before do
        allow(calendar_service).to receive(:list_calendar_lists).and_return(calendar_list_response)
        sign_in User.create! valid_officer_attributes
      end

      it 'retrieves calendars successfully and redirects to events' do
        get calendars_path

        expect(response).to redirect_to(events_url(calendar_id: valid_calendar_id))
      end
    end

    context 'with a logged in regular user account' do
      before do
        sign_in User.create! valid_attributes
      end

      it 'redirects to root' do
        get calendars_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /events' do
    context 'with invalid calendar_id but a logged in officer account' do
      before do
        sign_in User.create! valid_officer_attributes
      end
      it 'redirects to calendars_path' do
        get "/events/#{invalid_calendar_id}"
        expect(response).to redirect_to(calendars_path)
      end
    end
  end
end
