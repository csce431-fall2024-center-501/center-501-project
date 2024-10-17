class OfficerApplicationController < AuthenticatedApplicationController
    before_action :require_officer
end