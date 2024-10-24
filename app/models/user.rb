# frozen_string_literal: true

class User < ApplicationRecord
  # Validates that the email is present, unique, and properly formatted
  validates :email, presence: true, uniqueness: true, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: 'must be a valid email address'
  }

  # Validates that the full_name is present and has a minimum length of 2 characters
  validates :full_name, presence: true, length: {
    minimum: 2,
    too_short: 'must have at least %<count>s characters'
  }

  # Validates that the phone number is optional but must be 10 digits if provided
  validates :phone_number, allow_blank: true, format: {
    with: /\A\d{10}\z/,
    message: 'must be a valid 10-digit phone number'
  }

  # Date validations with upper and lower bounds
  validates :ring_date, :grad_date, inclusion: {
    in: Date.new(1900, 1, 1)..Date.new(Date.today.year + 4, 12, 31),
    message: "must be between 1900 and #{Date.today.year + 4}"
  }, allow_blank: true

  validates :birthday, inclusion: {
    in: Date.new(1900, 1, 1)..Date.new(Date.today.year - 18, 12, 31),
    message: 'must be at least 18 years old'
  }, allow_blank: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :user_projects
  has_many :projects, through: :user_projects

  # Create a user from Google OAuth and return it if the email doesn't already exist
  # If email is already in the database, it simply returns the user
  def self.from_google(email:, full_name:, uid:, avatar_url:, user_type:)
    create_with(uid:, full_name:, avatar_url:, user_type:).find_or_create_by!(email:)
  end

  # Quick officer check
  def officer?
    user_type == 'officer'
  end

  def atleast_officer?
    user_type == 'officer' || user_type == 'admin'
  end

  # Quick admin check
  def admin?
    user_type == 'admin'
  end
end
