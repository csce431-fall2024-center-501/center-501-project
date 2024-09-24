# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # after_sign_out_path_for is called when the user logs out
    def after_sign_out_path_for(_resource_or_scope)
      new_user_session_path
    end

    # after_sign_in_path_for is called when the user logs in
    # basically, if the user was trying to access a page that required authentication,
    # they will be redirected to that page after logging in
    # otherwise, they will be redirected to the root path
    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || root_path
    end
  end
end
