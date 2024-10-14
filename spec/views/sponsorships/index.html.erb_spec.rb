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

  it 'displays a New Sponsorship button' do
    expect(rendered).to have_selector('form button', text: 'New Sponsorship')
  end

  it 'renders a table with sponsorships' do
    expect(rendered).to have_selector('table')
    expect(rendered).to have_selector('th', text: 'Sponsor')
    expect(rendered).to have_selector('td', text: 'Rich Sponsor')
    expect(rendered).to have_selector('td', text: 'Test Sponsor')
  end

  it 'displays the Show button for each sponsorship' do
    expect(rendered).to have_selector('form button', text: 'Show', count: 2)
  end

  it "displays the 'Donate' button" do
    expect(rendered).to have_selector('form button', text: 'Donate')
  end

  it 'displays donation information' do
    expect(rendered).to have_text('$50')
    expect(rendered).to have_text('10 sq. ft. of road in the Dominican Republic')
    expect(rendered).to have_text('$400')
    expect(rendered).to have_text('1 latrine in Rwanda')
  end

  it "displays the 'Ways to Contribute' section" do
    expect(rendered).to have_text('Ways to Contribute')
    expect(rendered).to have_text('One-time/Monthly Donations')
    expect(rendered).to have_text('Your Expertise')
  end

  it 'displays the EWB Endowment section' do
    expect(rendered).to have_text('EWB Endowment')
    expect(rendered).to have_text('popham@tamu.edu')
  end
end
