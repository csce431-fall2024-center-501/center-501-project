require 'rails_helper'

RSpec.describe "photos/delete", type: :view do
  before do
    @photo = assign(:photo, Photo.create!(photoLink: "https://example.com/photo", photoDescription: "A sample photo", photoType: "Landscape", photoPageLocation: "Home"))
    render
  end

  it "displays the delete confirmation message" do
    expect(rendered).to match(/Are you sure you want to delete this photo?/)
  end

  it "displays the details of the photo" do
    expect(rendered).to match(/https:\/\/example.com\/photo/)
    expect(rendered).to match(/A sample photo/)
    expect(rendered).to match(/Landscape/)
    expect(rendered).to match(/Home/)
  end

  it "has a delete button and a cancel button" do
    expect(rendered).to have_selector("input[type=submit][value='Delete Photo']")
    expect(rendered).to have_link('Cancel', href: photos_path)
  end
end