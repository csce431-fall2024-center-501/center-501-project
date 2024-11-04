class Location < ApplicationRecord
    validates :address, presence: true
    validates :city, presence: true
    validates :state, presence: true
    validates :zip_code, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :country, presence: true
end
