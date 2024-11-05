# app/views/calendar/test_events.html.erb
require 'rails_helper'

RSpec.describe 'calendar/events.html.erb', type: :view do
  include Devise::Test::ControllerHelpers
  include TestAttributes
  include RequestHelpers
  let!(:officer) { User.create(valid_officer_attributes) } # Ensure the user has the necessary role

  before do
    sign_in officer
    assign(:calendar_id, 'c_35657eacaf7df0315b9988c9b68e72be62b3d78e730edd6583459300f61320db@group.calendar.google.com')
    assign(:event_list, OpenStruct.new(items: [
                                         OpenStruct.new(
                                           id: 'e_1',
                                           summary: 'Event 1',
                                           start: OpenStruct.new(date_time: '3023-10-01T10:00:00Z'),
                                           end: OpenStruct.new(date_time: '3023-10-01T12:00:00Z'),
                                           description: 'Description 1'
                                         ),
                                         OpenStruct.new(
                                           id: 'e_2',
                                           summary: 'Event 2',
                                           start: OpenStruct.new(date: '3023-10-02'),
                                           end: OpenStruct.new(date: '3023-10-03'),
                                           description: 'Description 2'
                                         )
                                       ]))
  end

  it 'displays the events correctly' do
    render
    expect(rendered).to have_content('Event 1')
    expect(rendered).to have_content('Start Time: 3023-10-01 10:00 AM')
    expect(rendered).to have_content('End Time: 3023-10-01 12:00 PM')
    expect(rendered).to have_content('Event 2')
    expect(rendered).to have_content('Start Date: 3023-10-02')
    expect(rendered).to have_content('End Date: 3023-10-03')
  end

  it 'displays the form correctly' do
    render
    expect(rendered).to have_selector('form')
    expect(rendered).to have_selector('input[name="event_name"]')
    expect(rendered).to have_selector('input[name="all_day"]')
    expect(rendered).to have_selector('input[type="submit"][value="Add event"]')
  end
end
