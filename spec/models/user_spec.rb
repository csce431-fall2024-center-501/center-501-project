# frozen_string_literal: true

# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  include TestAttributes
  
  describe 'validations' do
    let(:user) { User.new(email: 'test@example.com', full_name: 'John Doe', phone_number: '1234567890') }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      User.create(email: 'test@example.com', full_name: 'Jane Doe')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid with an improperly formatted email' do
      user.email = 'invalid-email'
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include('must be a valid email address')
    end

    it 'is invalid without a full_name' do
      user.full_name = nil
      expect(user).to_not be_valid
      expect(user.errors[:full_name]).to include("can't be blank")
    end

    it 'is invalid if the full_name is too short' do
      user.full_name = 'A'
      expect(user).to_not be_valid
      expect(user.errors[:full_name]).to include('must have at least 2 characters')
    end

    it 'is valid with a valid 10-digit phone number' do
      user.phone_number = '1234567890'
      expect(user).to be_valid
    end

    it 'is invalid with a phone number that is not 10 digits' do
      user.phone_number = '12345'
      expect(user).to_not be_valid
      expect(user.errors[:phone_number]).to include('must be a valid 10-digit phone number')
    end

    it 'is valid without a phone number' do
      user.phone_number = nil
      expect(user).to be_valid
    end
  end

  describe '.from_google' do
    it 'creates a new user with valid attributes if not already present' do
      expect do
        User.from_google(
          email: valid_attributes[:email],
          full_name: valid_attributes[:full_name],
          uid: valid_attributes[:uid],
          avatar_url: valid_attributes[:avatar_url],
          user_type: valid_attributes[:user_type]
        )
      end.to change(User, :count).by(1)

      user = User.find_by(email: valid_attributes[:email])
      expect(user.full_name).to eq(valid_attributes[:full_name])
      expect(user.uid).to eq(valid_attributes[:uid])
      expect(user.avatar_url).to eq(valid_attributes[:avatar_url])
      expect(user.user_type).to eq(valid_attributes[:user_type])
    end

    it 'finds an existing user by email without modifying attributes' do
      existing_user = User.create!(valid_attributes)
      expect do
        User.from_google(
          email: valid_attributes[:email],
          full_name: 'New Name',
          uid: 'new_uid',
          avatar_url: 'new_avatar_url',
          user_type: 'new_user_type'
        )
      end.not_to change(User, :count)

      user = User.find_by(email: valid_attributes[:email])
      expect(user).to eq(existing_user)
      expect(user.full_name).to eq(valid_attributes[:full_name]) # full_name remains unchanged
      expect(user.uid).to eq(valid_attributes[:uid]) # uid remains unchanged
      expect(user.avatar_url).to eq(valid_attributes[:avatar_url]) # avatar_url remains unchanged
      expect(user.user_type).to eq(valid_attributes[:user_type]) # user_type remains unchanged
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
