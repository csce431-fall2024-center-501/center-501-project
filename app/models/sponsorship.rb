class Sponsorship < ApplicationRecord
    validates :sponsor_name, presence: true
    validates :sponsor_lead_name, presence: true
    validates :sponsor_phone, presence: true
    validates :sponsor_email, presence: true
    validates :sponsor_donation, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :sponsor_end_of_contract, presence: true
end
