# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'projects/new', type: :view do
  before(:each) do
    assign(:project, Project.new(
                       projectName: 'MyString',
                       projectDesc: 'MyString',
                       projectStartDate: Date.today,
                       locationID: 1,
                       isProjectActive: false,
                       markdownBody: ''
                     ))
    Location.create(address: "12345", city: "College Station", state: "Texas", zip_code:"77840", country: "USA")
  end

  it 'renders new project form' do
    render

    assert_select 'form[action=?][method=?]', projects_path, 'post' do
      assert_select 'input[name=?]', 'project[projectName]'

      assert_select 'textarea[name=?]', 'project[projectDesc]'

      assert_select 'input[name=?][type=?]', 'project[projectStartDate]', 'date'

      assert_select 'select[name=?]', 'project[locationID]' do
        assert_select "option", "Please Assign a Location"
        assert_select "option", text: "College Station, Texas 77840, USA", value: Location.find_by(state: "Texas").id.to_s
      end

      assert_select 'input[name=?][type=?]', 'project[isProjectActive]', 'checkbox'

      assert_select 'textarea[name=?]', 'project[markdownBody]'
    end
  end
end
