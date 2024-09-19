# frozen_string_literal: true

class ApplicationController < ActionController::Base
    before_action :authenticate_user!

    private

    def require_admin
        unless current_user&.admin?
        flash[:alert] = "You must be an admin to access this section."
        redirect_to root_path # Redirect non-admin users
        end
    end
end
