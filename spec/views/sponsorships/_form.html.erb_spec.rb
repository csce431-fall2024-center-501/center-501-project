# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sponsorships/_form.html.erb', type: :view do
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
    render partial: 'sponsorships/form', locals: { sponsorship: }
  end

  it 'renders a text field for Sponsor Name' do
    expect(rendered).to have_selector("input[name='sponsorship[sponsor_name]'][value='Rich Sponsor']")
  end

  it 'renders a text field for Sponsor Lead Name' do
    expect(rendered).to have_selector("input[name='sponsorship[sponsor_lead_name]'][value='Rich Lead']")
  end

  it 'renders a text field for Sponsor Phone' do
    expect(rendered).to have_selector("input[name='sponsorship[sponsor_phone]'][value='9791234567']")
  end

  it 'renders a text field for Sponsor Email' do
    expect(rendered).to have_selector("input[name='sponsorship[sponsor_email]'][value='rich@gmail.com']")
  end

  it 'renders a number field for Sponsor Donation' do
    expect(rendered).to have_selector("input[name='sponsorship[sponsor_donation]'][value='188.88']")
  end

  it 'renders a date select field for Sponsor End of Contract' do
    expect(rendered).to have_selector("select[name='sponsorship[sponsor_end_of_contract(1i)]']")
    expect(rendered).to have_selector("select[name='sponsorship[sponsor_end_of_contract(2i)]']")
    expect(rendered).to have_selector("select[name='sponsorship[sponsor_end_of_contract(3i)]']")
  end

  it 'displays the form submission button' do
    expect(rendered).to have_selector("input[type='submit']")
  end
end
