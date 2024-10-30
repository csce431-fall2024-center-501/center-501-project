# frozen_string_literal: true

class AuthenticatedApplicationController < ApplicationController
  # require that the user is logged in
  before_action :authenticate_user!
end
