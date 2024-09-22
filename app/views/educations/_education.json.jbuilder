# frozen_string_literal: true

json.extract! education, :id, :educationName, :educationType, :educationDescription, :created_at, :updated_at
json.url education_url(education, format: :json)
