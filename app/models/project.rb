# frozen_string_literal: true

class Project < ApplicationRecord
  validates :projectName, presence: { message: 'Project Name cannot be left blank.' }
  validates :projectDesc, presence: { message: 'Project Description cannot be left blank.' }
  validates :projectStartDate, presence: { message: 'Starting Date for the project must be provided.' }
  validates :locationID, numericality: { greater_than: 0, message: 'Location ID must be greater than 0.' }
  validates :isProjectActive, inclusion: { in: [true, false] }
  validates :markdownBody, presence: false

  has_many :user_projects
  has_many :users, through: :user_projects

  def self.human_attribute_name(attr, _options = {})
    case attr
    when ''
    end
    ''
  end
end
