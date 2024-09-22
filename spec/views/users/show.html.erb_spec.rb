# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  include TestAttributes

  before(:each) do
    assign(:user, User.create!(valid_admin_attributes))
    allow(view).to receive(:current_user).and_return(User.create!(valid_attributes))
  end

  it 'displays user name' do
    render
    expect(rendered).to match(/#{valid_admin_attributes[:name]}/)
  end

  it 'displays user email' do
    render
    expect(rendered).to match(/#{valid_admin_attributes[:email]}/)
  end
end
