# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'educations/new', type: :view do
  before(:each) do
    assign(:education, Education.new(
                         educationName: 'MyString',
                         educationType: 'MyString',
                         educationDescription: 'MyString'
                       ))
  end

  it 'renders new education form' do
    render

    assert_select 'form[action=?][method=?]', educations_path, 'post' do
      assert_select 'input[name=?]', 'education[educationName]'

      assert_select 'select[name=?]', 'education[educationType]' do
        assert_select 'option[value=?]', 'major'
        assert_select 'option[value=?]', 'minor'
      end

      assert_select 'textarea[name=?]', 'education[educationDescription]'
    end
  end
end
