require 'rails_helper'

RSpec.describe "locations/show", type: :view do
  before do
    @location = Location.create!(
      address: "123 Main St",
      city: "Houston",
      state: "TX",
      zip_code: "77001",
      country: "USA"
    )
  end

  it "displays the location details" do
    render
    expect(rendered).to have_content("123 Main St")
    expect(rendered).to have_content("City: Houston")
    expect(rendered).to have_content("State: TX")
    expect(rendered).to have_content("Zip Code: 77001")
    expect(rendered).to have_content("Country: USA")
  end

  it "displays an 'Edit' link" do
    render
    expect(rendered).to have_link('Edit', href: edit_location_path(@location))
  end

  it "displays a 'Back' link" do
    render
    expect(rendered).to have_link('Back', href: locations_path)
  end
end
