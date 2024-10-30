require 'rails_helper'

RSpec.describe 'Adding a project to a user', type: :feature do
  include TestAttributes
  let!(:user) { User.create(valid_attributes) }
  let!(:project1) { Project.create(valid_project_attributes) }
  let!(:project2) { Project.create(valid_project_attributes2) }
  let!(:admin) { User.create(valid_admin_attributes) }
  
  context 'GET /show' do
    before do
      sign_in user
      user.projects << project1
    end
    
    it 'displays project 1 on the user page' do
      visit user_path(user)
      expect(page).to have_content(project1.projectName)
      expect(page).not_to have_content(project2.projectName)
    end

    it 'displays project 2 on the user page after adding it to user' do
      user.projects << project2
      visit user_path(user)
      expect(page).to have_content(project2.projectName)
    end
  end

  context 'GET /edit' do
    before do
      sign_in admin
      visit edit_user_path(user)
      user.projects << project1
    end

    it 'displays all projects' do
      expect(page).to have_content(project1.projectName)
      expect(page).to have_content(project2.projectName)
    end
  end
end
