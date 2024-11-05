# frozen_string_literal: true

# PagesController handles static pages within the application.
class PagesController < ApplicationController
  # GET /
  # Displays the home page and assigns photos marked for home gallery display.
  #
  # @return [void]
  def home
    @photos = Photo.where(displayed_in_home_gallery: true)
  end

  # GET /members
  # Displays the members page.
  #
  # @return [void]
  def members; end

  def help
    return if require_officer
  end
end
