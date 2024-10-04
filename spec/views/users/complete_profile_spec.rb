require 'rails_helper'

RSpec.describe "users/complete_profile", type: :view do
  before do
    assign(:user, User.new(
      phone_number: '1234567890',
      class_year: 2024,
      ring_date: Date.today,
      grad_date: Date.today + 1.year,
      birthday: Date.today - 20.years,
      shirt_size: 'M',
      dietary_restriction: 'None'
    ))
  end

  it "displays the correct form fields" do
    render

    # Check for form elements
    expect(rendered).to have_selector("form[action='#{update_profile_users_path}']")

    # Check each form field
    expect(rendered).to have_selector("input[name='user[phone_number]'][placeholder='Phone Number']")
    expect(rendered).to have_selector("input[name='user[class_year]'][placeholder='Class Year']")
    expect(rendered).to have_selector("select[name='user[ring_date(1i)]']")
    expect(rendered).to have_selector("select[name='user[grad_date(1i)]']")
    expect(rendered).to have_selector("select[name='user[birthday(1i)]']")
    expect(rendered).to have_selector("select[name='user[shirt_size]']")
    expect(rendered).to have_selector("select[name='user[dietary_restriction]']")

    # Check if the submit button is present
    expect(rendered).to have_selector("input[type='submit'][value='Update Profile']")
  end

  it "displays flash messages if present" do
    flash[:notice] = "Profile updated successfully"
    flash[:alert] = "There was an error updating the profile"

    render

    expect(rendered).to have_selector("div.flash.notice", text: "Profile updated successfully")
    expect(rendered).to have_selector("div.flash.alert", text: "There was an error updating the profile")
  end
end
