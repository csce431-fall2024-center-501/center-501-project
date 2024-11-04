# frozen_string_literal: true

class PagesController < ApplicationController
  def home; 
    @photos = Photo.where(displayed_in_home_gallery: true)
  end
  def members; end
end
