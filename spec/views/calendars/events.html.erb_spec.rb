require 'rails_helper'

RSpec.describe "calendar/events", type: :view do
  before do
    assign(:event_list, double('EventList', items: [
      double('Event', summary: 'Event 1', start: double('Start', date_time: DateTime.new(2024, 9, 25, 10, 0), date: nil)),
      double('Event', summary: 'Event 2', start: double('Start', date_time: nil, date: '2024-09-26'))
    ]))
    assign(:calendar_id, 'abc123')  # The calendar_id is required for the form action
  end

  it 'displays the events list with correct date and time' do
    render

    # Check for the event with a specific time
    expect(rendered).to include('2024-09-25 | 10:00 | Event 1')
    
    # Check for the event that is all-day
    expect(rendered).to include('2024-09-26 | All Day | Event 2')
  end

  it 'displays the form for adding a new event' do
    render

    # Ensure the form and its fields are present
    # expect(rendered).to have_selector("form[action='#{new_event_path('abc123')}']")
    expect(rendered).to have_selector("input[name='event_name']")
    expect(rendered).to have_selector("input[name='start_date'][type='date']")
    expect(rendered).to have_selector("input[name='end_date'][type='date']")
    expect(rendered).to have_selector("input[type='submit'][value='Add event']")
  end
end
