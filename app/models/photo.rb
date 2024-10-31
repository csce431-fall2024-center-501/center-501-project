class Photo < ApplicationRecord
    TYPES = %w[.jpg .png].freeze
    validates :description, presence: true
    validates :url, presence: true
    belongs_to :project, optional: true
end
