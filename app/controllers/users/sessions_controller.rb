# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # after_sign_out_path_for is called when the user logs out
    def after_sign_out_path_for(_resource_or_scope)
      new_user_session_path
    end
  end
end
