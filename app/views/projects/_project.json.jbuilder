# frozen_string_literal: true

json.extract! project, :id, :projectName, :projectDesc, :locationID, :projectStartDate, :isProjectActive, :created_at,
              :updated_at
json.url project_url(project, format: :json)
