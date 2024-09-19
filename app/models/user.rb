class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_google(email:, full_name:, uid:, avatar_url:, user_type:)
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url, user_type: user_type).find_or_create_by!(email: email)
  end

  def admin?
    user_type == 'admin'
  end
end
