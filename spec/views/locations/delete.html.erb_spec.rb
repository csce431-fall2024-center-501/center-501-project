require 'rails_helper'

RSpec.describe "locations/delete", type: :view do
  before do
    @location = Location.create!(
      address: "123 Main St",
      city: "Houston",
      state: "TX",
      zip_code: "77001",
      country: "USA"
    )
  end

  it "displays a confirmation message for deleting the location" do
    render
    expect(rendered).to have_content("Are you sure you want to delete this location?")
    expect(rendered).to have_content("Address: 123 Main St")
    expect(rendered).to have_content("City: Houston")
    expect(rendered).to have_content("State: TX")
    expect(rendered).to have_content("Zip Code: 77001")
    expect(rendered).to have_content("Country: USA")
  end

  it "displays a delete button with confirmation" do
    render
    expect(rendered).to have_selector("input[type=submit][value='Delete Location']")
  end

  it "displays a 'Cancel' link" do
    render
    expect(rendered).to have_link('Cancel', href: locations_path)
  end
end
