require 'rails_helper'

RSpec.describe "locations/new", type: :view do
  before do
    @location = Location.new
    allow(view).to receive(:action_name).and_return("new")
  end

  it "displays the new location form" do
    render
    expect(rendered).to have_selector("form")
    expect(rendered).to have_field('location[address]')
    expect(rendered).to have_field('location[city]')
    expect(rendered).to have_field('location[state]')
    expect(rendered).to have_field('location[zip_code]')
    expect(rendered).to have_field('location[country]')
  end

  it "displays error messages if any" do
    @location.errors.add(:address, "can't be blank")
    render
    expect(rendered).to have_content("can't be blank")
  end

  it "displays a 'Back' link" do
    render
    expect(rendered).to have_link('Back', href: locations_path)
  end
end
