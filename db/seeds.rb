# frozen_string_literal: true

require 'faker'

require 'faker'

100.times do
    User.create!(
        email: Faker::Internet.unique.email,
        full_name: Faker::Name.name,
        phone_number: Faker::PhoneNumber.unique.subscriber_number(length: 10), # Phone number
        ring_date: Faker::Date.between(from: '1990-01-01', to: Date.today),   # Date within range
        grad_date: Faker::Date.between(from: '1990-01-01', to: Date.today),   # Date within range
        birthday: Faker::Date.between(from: '1990-01-01', to: '2000-01-01'),                  # Birthday within range
        uid: Faker::Number.unique.number(digits: 10),
        avatar_url: Faker::Avatar.image,
        user_type: ['user', 'admin'].sample,                                                # Randomly assigns either 'user' or 'admin'
        class_year: Faker::Number.between(from: 1900, to: Date.today.year + 4),             # Random class year
        shirt_size: ['S', 'M', 'L', 'XL'].sample,                                           # Random shirt size
        dietary_restriction: ['None', 'Vegetarian', 'Vegan', 'Gluten-Free', 'Halal'].sample, # Random dietary restriction
        account_complete: true,
        linkedin_url: Faker::Internet.url
    )
end
