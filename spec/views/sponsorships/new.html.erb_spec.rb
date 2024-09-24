# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sponsorships/new.html.erb', type: :view do
  let(:sponsorship) { Sponsorship.new }

  before do
    assign(:sponsorship, sponsorship)
    render
  end

  it 'displays the new sponsorship header' do
    expect(rendered).to have_selector('h2', text: 'New Sponsorship')
  end

  it 'has a link to go back to the sponsorships list' do
    expect(rendered).to have_link('Back', href: sponsorships_path)
  end
end
