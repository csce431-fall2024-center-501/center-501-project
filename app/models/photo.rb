class Photo < ApplicationRecord
    TYPES = %w[.jpg .png].freeze
    validates :photoDescription, presence: true
    validates :photoType, presence: true
    validates :photoDescription, presence: true
end
