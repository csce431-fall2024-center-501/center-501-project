# OfficerApplicationController is a specialized controller that inherits from
# AuthenticatedApplicationController, providing access control for users with
# officer-level permissions.
class OfficerApplicationController < AuthenticatedApplicationController
    # Sets up a before action to ensure the current user has officer-level
    # permissions. Redirects unauthorized users to the root path.
    before_action :require_officer
  end
  