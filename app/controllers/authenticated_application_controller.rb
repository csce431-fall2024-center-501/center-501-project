# frozen_string_literal: true

# AuthenticatedApplicationController is a base controller that ensures user
# authentication before allowing access to any actions. Inherits from 
# ApplicationController, adding an additional authentication layer.
class AuthenticatedApplicationController < ApplicationController
  # Sets up a before action to ensure the user is logged in.
  # Redirects unauthenticated users to the login page.
  before_action :authenticate_user!
end
