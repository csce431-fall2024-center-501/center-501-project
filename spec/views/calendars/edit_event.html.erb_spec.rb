require 'rails_helper'

RSpec.describe 'calendar/edit_event.html.erb', type: :view do
  before do
    assign(:calendar_id, 1)
    assign(:event,
           double('Event', id: 1, summary: 'Test Event', start: double('Start', date_time: nil, date: Date.today),
                           end: double('End', date_time: nil, date: Date.today), description: 'Test Description'))
  end

  it 'renders the edit event form' do
    render

    expect(rendered).to have_selector('h1', text: 'Editing Test Event')
    expect(rendered).to have_selector("form[action='#{update_event_url(calendar_id: 1, event_id: 1)}']")
    expect(rendered).to have_field('event_name', with: 'Test Event')
    expect(rendered).to have_checked_field('all_day')
    expect(rendered).to have_selector('#date-fields')
    expect(rendered).to have_field('start_date', with: Date.today.to_s)
    expect(rendered).to have_field('end_date', with: Date.today.to_s)
    expect(rendered).to have_field('description', text: 'Test Description')
    expect(rendered).to have_selector("input[type=submit][value='Update Event']")
    expect(rendered).to have_link('Back to Events', href: events_url(calendar_id: 1))
  end
end
