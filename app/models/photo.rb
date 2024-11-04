class Photo < ApplicationRecord
    validates :description, presence: true
    validates :url, presence: true
    belongs_to :project, optional: true
end
