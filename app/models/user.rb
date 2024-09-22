# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  # create a user from google oauth and returns it if email doesn't already exist
  # if email is already in the database, it simply return the user
  def self.from_google(email:, full_name:, uid:, avatar_url:, user_type:)
    create_with(uid:, full_name:, avatar_url:,
                user_type:).find_or_create_by!(email:)
  end

  # quick admin check
  def admin?
    user_type == 'admin'
  end
end
