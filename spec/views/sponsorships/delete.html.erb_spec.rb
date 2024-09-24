# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sponsorships/delete.html.erb', type: :view do
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

  it 'displays the delete sponsorship header' do
    expect(rendered).to have_selector('h2', text: 'Delete Sponsorship')
  end

  it 'has a link back to the sponsorships list' do
    expect(rendered).to have_link('Back', href: sponsorships_path)
  end

  it 'asks for confirmation to delete the sponsorship' do
    expect(rendered).to match(/Are you sure you want to permanently delete this sponsorship?/)
  end

  it 'displays the sponsorship name' do
    expect(rendered).to have_selector('.reference-name', text: sponsorship.sponsor_name)
  end

  it 'renders a form to delete the sponsorship' do
    expect(rendered).to have_selector("form[action=\"#{sponsorship_path(sponsorship)}\"][method=\"post\"]")
    expect(rendered).to have_selector('input[type="submit"][value="Delete Sponsorship"]')
  end
end
