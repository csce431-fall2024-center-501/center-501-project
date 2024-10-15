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
  end

  it 'renders new project form' do
    render

    assert_select 'form[action=?][method=?]', projects_path, 'post' do
      assert_select 'input[name=?]', 'project[projectName]'

      assert_select 'textarea[name=?]', 'project[projectDesc]'

      assert_select 'input[name=?][type=?]', 'project[projectStartDate]', 'date'

      assert_select 'input[name=?][type=?]', 'project[locationID]', 'number'

      assert_select 'input[name=?][type=?]', 'project[isProjectActive]', 'checkbox'

      assert_select 'textarea[name=?]', 'project[markdownBody]'
    end
  end
end
