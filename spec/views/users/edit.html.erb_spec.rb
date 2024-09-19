require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  include TestAttributes

  let(:user) {
    User.create! valid_attributes
  }

  before(:each) do
    assign(:user, user)
    allow(view).to receive(:current_user).and_return(User.create!(valid_admin_attributes))
  end

  it "renders the edit user form" do
    render
    assert_select "form[action=?][method=?]", user_path(user), "post" do
    end
  end
end
