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

      assert_select 'input[name=?]', 'education[educationType]'

      assert_select 'textarea[name=?]', 'education[educationDescription]'
    end
  end
end
