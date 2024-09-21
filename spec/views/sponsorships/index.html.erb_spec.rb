# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sponsorships/index.html.erb', type: :view do
  let(:valid_attributes1) do
    {
      sponsor_name: 'Rich Sponsor',
      sponsor_lead_name: 'Rich Lead',
      sponsor_phone: '9791234567',
      sponsor_email: 'rich@gmail.com',
      sponsor_donation: 188.80,
      sponsor_end_of_contract: '2025-12-31'
    }
  end

  let(:valid_attributes2) do
    {
      sponsor_name: 'Test Sponsor',
      sponsor_lead_name: 'Test Lead',
      sponsor_phone: '9791234567',
      sponsor_email: 'test@gmail.com',
      sponsor_donation: 500.50,
      sponsor_end_of_contract: '2025-12-31'
    }
  end

  let(:sponsorship1) { Sponsorship.create!(valid_attributes1) }
  let(:sponsorship2) { Sponsorship.create!(valid_attributes2) }

  before do
    assign(:sponsorships, [sponsorship1, sponsorship2])
    render
  end

  it 'displays the Sponsorships heading' do
    expect(rendered).to have_selector('h1', text: 'Sponsorships')
  end

  it 'has a link to create a new sponsorship' do
    expect(rendered).to have_link('New Sponsorship', href: new_sponsorship_path)
  end

  it 'renders a table with sponsorships' do
    expect(rendered).to have_selector('table')
    expect(rendered).to have_selector('th', text: 'Sponsor')
    expect(rendered).to have_selector('td', text: 'Rich Sponsor')
    expect(rendered).to have_selector('td', text: 'Test Sponsor')
  end

  it 'renders a Show link for each sponsorship' do
    expect(rendered).to have_link('Show', href: sponsorship_path(sponsorship1))
    expect(rendered).to have_link('Show', href: sponsorship_path(sponsorship2))
  end
end
