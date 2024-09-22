# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/new', type: :view do
  include TestAttributes

  before(:each) do
    assign(:user, User.new)
    allow(view).to receive(:current_user).and_return(User.create!(valid_admin_attributes))
  end

  it 'renders new user form' do
    render
    assert_select 'form[action=?][method=?]', users_path, 'post' do
      assert_select 'input[name=?]', 'user[email]'
      assert_select 'input[name=?]', 'user[full_name]'
      assert_select 'input[type=?]', 'submit'
    end
  end
end
