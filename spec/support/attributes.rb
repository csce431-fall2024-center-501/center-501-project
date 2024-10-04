# frozen_string_literal: true

# spec/support/attributes.rb
module TestAttributes
  def valid_attributes
    {
      email: 'testuser@example.com',
      full_name: 'Test User',
      uid: '1234567890',
      avatar_url: 'http://example.com/avatar.jpg',
      user_type: 'user',
      phone_number: '1234567890',
      class_year: 2020
    }
  end

  def valid_admin_attributes
    {
      email: 'testuser-admin@example.com',
      full_name: 'Test User',
      uid: '1234567890',
      avatar_url: 'http://example.com/avatar.jpg',
      user_type: 'admin',
      phone_number: '1234567890',
      class_year: 2020
    }
  end

  def invalid_attributes
    {
      email: nil,
      full_name: '',
      uid: nil,
      avatar_url: 'not_a_valid_url',
      user_type: 'invalid_type'
    }
  end
end
