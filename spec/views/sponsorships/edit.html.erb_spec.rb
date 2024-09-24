# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sponsorships/edit.html.erb', type: :view do
  let(:valid_attributes) do
    {
      sponsor_name: 'Rich Sponsor',
      sponsor_lead_name: 'Rich Lead',
      sponsor_phone: '9791234567',
      sponsor_email: 'rich@gmail.com',
      sponsor_donation: 188.80,
      sponsor_end_of_contract: '2025-12-31'
    }
  end

  let(:sponsorship) { Sponsorship.create!(valid_attributes) }

  before do
    assign(:sponsorship, sponsorship)
    render
  end

  it 'displays the edit sponsorship header' do
    expect(rendered).to have_selector('h2', text: 'Edit Sponsorship')
  end

  it 'has a link back to the sponsorships list' do
    expect(rendered).to have_link('Back', href: sponsorships_path)
  end

  it 'has a link to view the sponsorship' do
    expect(rendered).to have_link('Show', href: sponsorship_path(sponsorship))
  end
end
