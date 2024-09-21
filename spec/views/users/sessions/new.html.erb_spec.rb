# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/sessions/new', type: :view do
  it 'renders the log in page' do
    render
    expect(rendered).to have_selector('h2.logout-message', text: 'Member Login')
    expect(rendered).to have_button('Sign in with Google')
    expect(rendered).to have_selector("form[action='#{user_google_oauth2_omniauth_authorize_path}'][method='post']")
  end
end
