# frozen_string_literal: true

class PagesController < ApplicationController
  def home; 
    @photos = Photo.where(photoPageLocation: 'Home')
  end
end
