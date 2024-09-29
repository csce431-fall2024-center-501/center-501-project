require 'rails_helper'

RSpec.describe "calendar/calendars", type: :view do
  before do
    assign(:calendar_list, [
      double('Calendar', id: 1, summary: 'Calendar 1'),
      double('Calendar', id: 2, summary: 'Calendar 2')
    ])
  end

  it 'displays the calendar summaries' do
    render

    expect(rendered).to include('Calendar 1')
    expect(rendered).to include('Calendar 2')
  end

  it 'displays buttons with correct links' do
    render

    expect(rendered).to have_selector("button[onclick=\"window.location.href='#{events_path(1)}'\"]", text: 'Open')
    expect(rendered).to have_selector("button[onclick=\"window.location.href='#{events_path(2)}'\"]", text: 'Open')
  end
end
