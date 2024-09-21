# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sponsorships/show.html.erb', type: :view do
  let(:valid_attributes) do
    {
      sponsor_name: 'Rich Sponsor',
      sponsor_lead_name: 'Rich Lead',
      sponsor_phone: '9791234567',
      sponsor_email: 'rich@gmail.com',
      sponsor_donation: 188.88,
      sponsor_end_of_contract: '2025-12-31'
    }
  end

  let(:sponsorship) { Sponsorship.create!(valid_attributes) }

  before do
    assign(:sponsorship, sponsorship)
    render
  end

  it 'displays the show sponsorship header' do
    expect(rendered).to have_selector('h2', text: 'Show Sponsorship')
  end

  it 'has a link back to the sponsorships list' do
    expect(rendered).to have_link('Back', href: sponsorships_path)
  end

  it 'has an edit link' do
    expect(rendered).to have_link('Edit', href: edit_sponsorship_path(sponsorship))
  end

  it 'has a delete link' do
    expect(rendered).to have_link('Delete', href: delete_sponsorship_path(sponsorship))
  end

  it 'renders the sponsorship details' do
    expect(rendered).to have_selector('th', text: 'Sponsor Name')
    expect(rendered).to have_selector('td', text: 'Rich Sponsor')

    expect(rendered).to have_selector('th', text: 'Lead Name')
    expect(rendered).to have_selector('td', text: 'Rich Lead')

    expect(rendered).to have_selector('th', text: 'Phone')
    expect(rendered).to have_selector('td', text: '9791234567')

    expect(rendered).to have_selector('th', text: 'Email')
    expect(rendered).to have_selector('td', text: 'rich@gmail.com')

    expect(rendered).to have_selector('th', text: 'Donation')
    expect(rendered).to have_selector('td', text: '188.88')

    expect(rendered).to have_selector('th', text: 'End of Contract')
    expect(rendered).to have_selector('td', text: '2025-12-31')
  end
end
