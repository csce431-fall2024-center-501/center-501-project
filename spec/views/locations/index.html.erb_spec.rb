require 'rails_helper'

RSpec.describe "locations/index", type: :view do
  before do
    assign(:locations, [
      Location.create!(
        address: "123 Main St",
        city: "Houston",
        state: "TX",
        zip_code: "77001",
        country: "USA"
      ),
      Location.create!(
        address: "456 Elm St",
        city: "Austin",
        state: "TX",
        zip_code: "73301",
        country: "USA"
      )
    ])
  end

  it "displays a list of locations with links" do
    render
    expect(rendered).to have_link('123 Main St', href: location_path(Location.first))
    expect(rendered).to have_link('456 Elm St', href: location_path(Location.second))
  end

  it "displays edit and destroy links for each location" do
    render
    Location.all.each do |location|
      expect(rendered).to have_link('Edit', href: edit_location_path(location))
      expect(rendered).to have_link('Destroy', href: location_path(location), method: :delete)
    end
  end

  it "displays a 'New Location' link" do
    render
    expect(rendered).to have_link('New Location', href: new_location_path)
  end
end
