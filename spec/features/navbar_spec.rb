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
  scenario "displays 'Sponsors & Donations' link" do
    visit root_path

    within('nav') do
      expect(page).to have_link('Sponsors & Donations', href: sponsorships_path)
    end
  end
end

RSpec.feature 'Navbar', type: :feature do
  scenario "displays 'Projects' link" do
    visit root_path

    within('nav') do
      expect(page).to have_link('Projects', href: projects_path)
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
  scenario "'Sponsors & Donations' link has active class when on the sponsorships page" do
    visit sponsorships_path

    within('nav') do
      expect(page).to have_css('a.active', text: 'Sponsors & Donations')
    end
  end
end

RSpec.feature 'Navbar', type: :feature do
  scenario "'Projects' link has active class when on the projects page" do
    visit projects_path

    within('nav') do
      expect(page).to have_css('a.active', text: 'Projects')
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

RSpec.feature 'Navbar', type: :feature do
  scenario "'Home' link does not have active class on non-home pages" do
    visit new_user_session_path

    within('nav') do
      expect(page).to have_link('Home', href: root_path)
      expect(page).not_to have_css('a.active', text: 'Home')
    end
  end
end

RSpec.feature 'Navbar', type: :feature do
  scenario "'Log In' link does not have active class on non-home pages" do
    visit root_path # visit the homepage

    within('nav') do
      expect(page).to have_link('Log In', href: new_user_session_path)
      expect(page).not_to have_css('a.active', text: 'Log In')
    end
  end
end

RSpec.feature 'Navbar', type: :feature do
  include TestAttributes
  scenario "'Members' link takes user to membership page when user is not signed in" do
    visit root_path

    within('nav') do
      click_link 'Members'
    end

    expect(page).to have_current_path(members_path)
  end

  scenario "'Members' link takes user to member directory page when user is signed in" do
    user = User.create! valid_attributes
    sign_in user

    visit root_path

    within('nav') do
      click_link 'Members'
    end

    expect(page).to have_current_path(users_path)
  end
end
