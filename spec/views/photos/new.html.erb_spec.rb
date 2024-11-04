require 'rails_helper'

RSpec.describe "photos/new", type: :view do
  before do
    assign(:photo, Photo.new)
    @projects = Project.all
    allow(view).to receive(:action_name).and_return("new")
  end

  it "displays the form fields for creating a new photo" do
    render
    expect(rendered).to have_selector("input[name='photo[description]']")
  end
end

