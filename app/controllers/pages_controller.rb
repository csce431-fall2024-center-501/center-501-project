# frozen_string_literal: true

class PagesController < ApplicationController
  def home; 
    @photos = Photo.all
  end
end
