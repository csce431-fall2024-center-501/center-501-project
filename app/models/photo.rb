class Photo < ApplicationRecord
    TYPES = %w[.jpg .png].freeze
    validates :photo_type, presence: true
    validates :photo_description, presence: true
    validates :url, presence: true
    belongs_to :project, optional: true
end
