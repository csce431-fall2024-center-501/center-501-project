require 'rails_helper'

RSpec.describe 'calendar/event.html.erb', type: :view do
  before do
    assign(:event, event)
    assign(:calendar_id, 'test_calendar_id')
    allow(view).to receive(:current_user).and_return(user)
  end

  let(:user) { instance_double(User, atleast_officer?: true) }
  let(:event) do
    instance_double(
      'Event',
      summary: 'Test Event',
      start: OpenStruct.new(date_time: DateTime.now, date: nil),
      end: OpenStruct.new(date_time: DateTime.now + 1.hour, date: nil),
      html_link: 'http://example.com',
      description: 'Event Description',
      id: 1
    )
  end

  it 'displays the event summary' do
    render
    expect(rendered).to match(/Test Event/)
  end

  it 'displays the start and end time' do
    render
    expect(rendered).to match(/Start Time:/)
    expect(rendered).to match(/End Time:/)
  end

  it 'displays the Google Calendar link' do
    render
    expect(rendered).to have_link('See in Google Calendar', href: 'http://example.com')
  end

  it 'displays the edit and delete buttons for officers' do
    render
    expect(rendered).to have_link('Edit Event')
    expect(rendered).to have_link('Delete Event')
  end

  it 'displays the back to events button' do
    render
    expect(rendered).to have_link('Back to Events')
  end
end
