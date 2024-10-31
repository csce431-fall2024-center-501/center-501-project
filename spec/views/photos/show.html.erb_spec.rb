# spec/views/photos/show.html.erb_spec.rb
require 'rails_helper'

RSpec.describe "photos/show", type: :view do
  before do
    @photo = assign(:photo, Photo.create!(url: "https://example.com/photo1", photo_description: "Description 1", photo_type: "Type1", displayed_in_home_gallery: true))
    render
  end

  it "displays the photo details" do
    expect(rendered).to have_link("https://example.com/photo1", href: "https://example.com/photo1")
    expect(rendered).to have_content("Description 1")
    expect(rendered).to have_content("Type1")
  end

  it "has an Edit link" do
    expect(rendered).to have_link("Edit", href: edit_photo_path(@photo))
  end

  it "has a Back link" do
    expect(rendered).to have_link("Back", href: photos_path)
  end
end
