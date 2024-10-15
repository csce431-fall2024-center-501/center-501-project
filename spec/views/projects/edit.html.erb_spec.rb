# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'projects/edit', type: :view do
  let(:project) do
    Project.create!(
      projectName: 'MyString',
      projectDesc: 'MyString',
      projectStartDate: Date.today,
      locationID: 1,
      isProjectActive: false,
      markdownBody: ''
    )
  end

  before(:each) do
    assign(:project, project)
  end

  it 'renders the edit project form' do
    render

    assert_select 'form[action=?][method=?]', project_path(project), 'post' do
      assert_select 'input[name=?]', 'project[projectName]'

      assert_select 'textarea[name=?]', 'project[projectDesc]'

      assert_select 'input[name=?][type=?]', 'project[projectStartDate]', 'date'

      assert_select 'input[name=?][type=?]', 'project[locationID]', 'number'

      assert_select 'input[name=?][type=?]', 'project[isProjectActive]', 'checkbox'

      assert_select 'textarea[name=?]', 'project[markdownBody]'
    end
  end
end
