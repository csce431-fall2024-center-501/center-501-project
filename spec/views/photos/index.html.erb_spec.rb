# spec/views/photos/index.html.erb_spec.rb
require 'rails_helper'

RSpec.describe "photos/index", type: :view do
  before do
    assign(:photos, [
      Photo.create!(photoLink: "https://example.com/photo1", photoDescription: "Description 1", photoType: "Type1", photoPageLocation: "Home"),
      Photo.create!(photoLink: "https://example.com/photo2", photoDescription: "Description 2", photoType: "Type2", photoPageLocation: "Gallery")
    ])
    render
  end

  it "displays all photos" do
    expect(rendered).to have_link("https://example.com/photo1", href: "https://example.com/photo1")
    expect(rendered).to have_content("Description 1")
    expect(rendered).to have_content("Type1")
    expect(rendered).to have_content("Home")

    expect(rendered).to have_link("https://example.com/photo2", href: "https://example.com/photo2")
    expect(rendered).to have_content("Description 2")
    expect(rendered).to have_content("Type2")
    expect(rendered).to have_content("Gallery")
  end

  it "has a New Photo link" do
    expect(rendered).to have_link("New Photo", href: new_photo_path)
  end

  it "displays the correct headers" do
    expect(rendered).to have_selector("th", text: "Photo Link")
    expect(rendered).to have_selector("th", text: "Description")
    expect(rendered).to have_selector("th", text: "Type")
    expect(rendered).to have_selector("th", text: "Page Location")
  end

  it "displays links to the photos with truncation" do
    render
    expect(rendered).to have_link(href: "https://example.com/photo1")
  end

  it "shows edit and delete buttons for each photo" do
    expect(rendered).to have_link('Edit', href: edit_photo_path(Photo.first))
    expect(rendered).to have_link('Delete', href: delete_photo_path(Photo.first))
  end

  it "displays a link to add a new photo" do
    expect(rendered).to have_link('New Photo', href: new_photo_path)
  end
end
