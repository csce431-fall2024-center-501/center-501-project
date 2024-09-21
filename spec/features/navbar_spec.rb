# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Navbar', type: :feature do
  scenario "displays 'Home' link" do
    visit root_path

    within('nav') do
      expect(page).to have_link('Home', href: root_path)
    end
  end
end

RSpec.feature 'Navbar', type: :feature do
  scenario "displays 'Log In' link" do
    visit root_path

    within('nav') do
      expect(page).to have_link('Log In', href: new_user_session_path)
    end
  end
end

RSpec.feature 'Navbar', type: :feature do
  scenario "'Home' link has active class when on the homepage" do
    visit root_path

    within('nav') do
      expect(page).to have_css('a.active', text: 'Home')
    end
  end
end

RSpec.feature 'Navbar', type: :feature do
  scenario "'Log In' link has active class when on the login page" do
    visit new_user_session_path

    within('nav') do
      expect(page).to have_css('a.active', text: 'Log In')
    end
  end
end

RSpec.feature "Navbar", type: :feature do
  scenario "'Home' link does not have active class on non-home pages" do
    visit new_user_session_path

    within('nav') do
      expect(page).to have_link('Home', href: root_path)
      expect(page).not_to have_css('a.active', text: 'Home')
    end
  end
end

RSpec.feature "Navbar", type: :feature do
  scenario "'Log In' link does not have active class on non-home pages" do
    visit root_path # Replace with a path other than root_path

    within('nav') do
      expect(page).to have_link('Log In', href: new_user_session_path)
      expect(page).not_to have_css('a.active', text: 'Log In')
    end
  end
end
