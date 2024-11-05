# AdminApplicationController is a specialized controller that inherits from
# AuthenticatedApplicationController, enforcing access control for users with
# admin-level permissions.
class AdminApplicationController < AuthenticatedApplicationController
  # Sets up a before action to ensure the current user has admin-level
  # permissions. Redirects unauthorized users to the root path.
  before_action :require_admin
end
