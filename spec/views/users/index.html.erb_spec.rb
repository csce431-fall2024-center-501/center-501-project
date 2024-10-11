# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  include TestAttributes

  before(:each) do
    assign(:users, [
             User.create!(valid_attributes),
             User.create!(valid_admin_attributes)
           ])
    assign(:attributes, %i[email full_name user_type])
    assign :select_attributes, %i[email full_name user_type]
    allow(view).to receive(:current_user).and_return(User.last)
  end

  it 'renders a list of users' do
    render
    'div>p'
  end

  it 'displays selected attributes' do
    render
    expect(rendered).to match(/#{valid_attributes[:name]}/)
    expect(rendered).to match(/#{valid_admin_attributes[:name]}/)
    expect(rendered).to match(/#{valid_attributes[:email]}/)
    expect(rendered).to match(/#{valid_admin_attributes[:email]}/)
    expect(rendered).to match(/#{valid_attributes[:user_type]}/)
    expect(rendered).to match(/#{valid_admin_attributes[:user_type]}/)
  end

  it 'doesn\'t display unselected attributes' do
    render
    expect(rendered).not_to match(/#{valid_attributes[:phone_number]}/)
    expect(rendered).not_to match(/#{valid_admin_attributes[:phone_number]}/)
    expect(rendered).not_to match(/#{valid_attributes[:class_year]}/)
    expect(rendered).not_to match(/#{valid_admin_attributes[:class_year]}/)
    expect(rendered).not_to match(/#{valid_attributes[:dietary_restriction]}/)
  end
end
