# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  include TestAttributes

  before(:each) do
    assign(:users, [
             User.create!(valid_attributes),
             User.create!(valid_admin_attributes)
           ])
    allow(view).to receive(:current_user).and_return(User.last)
  end

  it 'renders a list of users' do
    render
    'div>p'
  end

  it 'displays user names' do
    render
    expect(rendered).to match(/#{valid_attributes[:name]}/)
    expect(rendered).to match(/#{valid_admin_attributes[:name]}/)
  end

  it 'displays user emails' do
    render
    expect(rendered).to match(/#{valid_attributes[:email]}/)
    expect(rendered).to match(/#{valid_admin_attributes[:email]}/)
  end
end
