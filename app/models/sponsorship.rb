class Sponsorship < ApplicationRecord
    validates :sponsorName, presence: true
    validates :sponsorLeadName, presence: true
    validates :sponsorPhone, presence: true
    validates :sponsorEmail, presence: true
    validates :sponsorDonation, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :sponsorEndOfContract, presence: true
end
