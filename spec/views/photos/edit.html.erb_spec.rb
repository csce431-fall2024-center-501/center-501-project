require 'rails_helper'

RSpec.describe "photos/edit", type: :view do
  before do
    @photo = Photo.create!(url: "https://example.com/photo1", description: "A sample photo", displayed_in_home_gallery: true)
    @projects = Project.all
    allow(view).to receive(:action_name).and_return("edit")
  end

  it "displays the form fields for editing a photo" do
    render
    expect(rendered).to have_selector("input[name='photo[description]'][value='A sample photo']")
  end

  it "displays error messages if any" do
    @photo.errors.add(:url, "can't be blank")
    render
    expect(rendered).to have_content("can't be blank")
  end
end


