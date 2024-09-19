# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  include TestAttributes

  describe 'validations' do
    it 'validates presence of email' do
      user = User.new(invalid_attributes)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'validates uniqueness of email' do
      existing_user = User.create!(valid_attributes)
      user = User.new(email: valid_attributes[:email])
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end
  end

  describe '.from_google' do
    it 'creates a new user with valid attributes if not already present' do
      expect {
        User.from_google(
          email: valid_attributes[:email],
          full_name: valid_attributes[:full_name],
          uid: valid_attributes[:uid],
          avatar_url: valid_attributes[:avatar_url],
          user_type: valid_attributes[:user_type]
        )
      }.to change(User, :count).by(1)
      
      user = User.find_by(email: valid_attributes[:email])
      expect(user.full_name).to eq(valid_attributes[:full_name])
      expect(user.uid).to eq(valid_attributes[:uid])
      expect(user.avatar_url).to eq(valid_attributes[:avatar_url])
      expect(user.user_type).to eq(valid_attributes[:user_type])
    end

    it 'finds an existing user by email without modifying attributes' do
      existing_user = User.create!(valid_attributes)
      expect {
        User.from_google(
          email: valid_attributes[:email],
          full_name: 'New Name',
          uid: 'new_uid',
          avatar_url: 'new_avatar_url',
          user_type: 'new_user_type'
        )
      }.not_to change(User, :count)

      user = User.find_by(email: valid_attributes[:email])
      expect(user).to eq(existing_user)
      expect(user.full_name).to eq(valid_attributes[:full_name])  # full_name remains unchanged
      expect(user.uid).to eq(valid_attributes[:uid])  # uid remains unchanged
      expect(user.avatar_url).to eq(valid_attributes[:avatar_url])  # avatar_url remains unchanged
      expect(user.user_type).to eq(valid_attributes[:user_type])  # user_type remains unchanged
    end
  end

  describe '#admin?' do
    it 'returns true if user_type is admin' do
      user = User.new(valid_admin_attributes)
      expect(user.admin?).to be(true)
    end

    it 'returns false if user_type is not admin' do
      user = User.new(valid_attributes)
      expect(user.admin?).to be(false)
    end
  end
end
