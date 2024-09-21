# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/edit', type: :view do
  include TestAttributes

  let(:user) do
    User.create! valid_attributes
  end

  before(:each) do
    assign(:user, user)
    allow(view).to receive(:current_user).and_return(User.create!(valid_admin_attributes))
  end

  it 'renders the edit user form' do
    render
    assert_select 'form[action=?]', user_path(user) do
      assert_select 'input[name=?]', 'user[email]'
      assert_select 'input[name=?]', 'user[full_name]'
      assert_select 'input[type=?]', 'submit'
    end
  end
end
