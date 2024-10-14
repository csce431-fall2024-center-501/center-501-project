require 'rails_helper'

RSpec.describe "photos/edit", type: :view do
  before do
    @photo = Photo.create!(photoLink: "https://example.com/photo1", photoDescription: "A sample photo", photoType: "jpg", photoPageLocation: "Gallery")
    allow(view).to receive(:action_name).and_return("edit")
  end

  it "displays the form fields for editing a photo" do
    render
    expect(rendered).to have_selector("input[name='photo[photoLink]']")
  end

  it "displays error messages if any" do
    @photo.errors.add(:photoLink, "can't be blank")
    render
    expect(rendered).to have_content("can't be blank")
  end
end


