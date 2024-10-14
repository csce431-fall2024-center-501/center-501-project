require 'rails_helper'

RSpec.describe "locations/edit", type: :view do
  before do
    @location = Location.create!(
      address: "123 Main St",
      city: "Houston",
      state: "TX",
      zip_code: "77001",
      country: "USA"
    )
    allow(view).to receive(:action_name).and_return("edit")
  end

  it "displays the edit form for a location" do
    render
    expect(rendered).to have_selector("form")
    expect(rendered).to have_field('location[address]', with: "123 Main St")
    expect(rendered).to have_field('location[city]', with: "Houston")
    expect(rendered).to have_field('location[state]', with: "TX")
    expect(rendered).to have_field('location[zip_code]', with: "77001")
    expect(rendered).to have_field('location[country]', with: "USA")
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
