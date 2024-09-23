# frozen_string_literal: true

class AuthenticatedApplicationController < ApplicationController
  # require that the user is logged in
  before_action :authenticate_user!

  private

  # function to quickly ensure that logged in user is an admin
  # redirects to root path if not an admin
  # returns false if not an admin
  # returns true if admin - this is to help prevent mutiple redirects/renders and communicate the result of the check
  def require_admin
    unless current_user&.admin?
      flash[:alert] = 'You must be an admin to access this section.'
      redirect_to root_path # Redirect non-admin users
      return false
    end
    true
  end
end
