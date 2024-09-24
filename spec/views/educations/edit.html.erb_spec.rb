# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'educations/edit', type: :view do
  let(:education) do
    Education.create!(
      educationName: 'MyString',
      educationType: 'MyString',
      educationDescription: 'MyString'
    )
  end

  before(:each) do
    assign(:education, education)
  end

  it 'renders the edit education form' do
    render

    assert_select 'form[action=?][method=?]', education_path(education), 'post' do
      assert_select 'input[name=?]', 'education[educationName]'

      assert_select 'input[name=?]', 'education[educationType]'

      assert_select 'textarea[name=?]', 'education[educationDescription]'
    end
  end
end
