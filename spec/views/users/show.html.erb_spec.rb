# frozen_string_literal: true

require 'rails_helper'

# TODO: - improve tests by distinguishing between user types

RSpec.describe 'users/show', type: :view do
  include TestAttributes

  before(:each) do
    assign(:user, User.create!(valid_admin_attributes))
    allow(view).to receive(:current_user).and_return(User.create!(valid_attributes))
    assign(:attributes, %i[email full_name user_type])
    assign(:projects, [Project.create!(valid_project_attributes), Project.create!(valid_project_attributes2)])
  end

  it 'displays user name' do
    render
    expect(rendered).to match(/#{valid_admin_attributes[:name]}/)
  end

  it 'displays user email' do
    render
    expect(rendered).to match(/#{valid_admin_attributes[:email]}/)
  end

  it 'displays user type' do
    render
    expect(rendered).to match(/#{valid_admin_attributes[:user_type]}/)
  end

  it 'displays user projects' do
    render
    expect(rendered).to match(/#{valid_project_attributes[:projectName]}/)
    expect(rendered).to match(/#{valid_project_attributes2[:projectName]}/)
  end
end
