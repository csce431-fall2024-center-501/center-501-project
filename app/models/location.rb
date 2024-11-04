class Location < ApplicationRecord
    validates :address, presence: true
    validates :city, presence: true
    validates :state, presence: true
    validates :zip_code, presence: true, format: { with: /\A\d{5}(-\d{4})?\z/, message: "must be a valid US ZIP code" }
    validates :country, presence: true
end
