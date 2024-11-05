# frozen_string_literal: true

# UsersController manages user records, including CRUD operations, profile
# updates, CSV export, and attribute-based access control.
class UsersController < AuthenticatedApplicationController
  # Sets the user and projects for actions that require them.
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_projects, only: %i[edit new]
  
  # Default attributes shown in user listings.
  INITIAL_SELECT_ATTRIBUTES = %i[full_name email phone_number class_year linkedin_url].freeze

  # Attributes accessible by admins.
  ADMIN_ACCESS_ATTRIBUTES = %i[full_name email user_type phone_number class_year ring_date grad_date birthday
                               shirt_size dietary_restriction account_complete created_at updated_at linkedin_url].freeze

  # Attributes accessible by officers.
  OFFICER_ACCESS_ATTRIBUTES = %i[full_name email user_type phone_number class_year ring_date grad_date birthday
                                 shirt_size dietary_restriction account_complete created_at updated_at linkedin_url].freeze

  # Attributes accessible by regular users.
  USER_ACCESS_ATTRIBUTES = %i[full_name email phone_number class_year linkedin_url].freeze

  # GET /users or /users.json
  # Lists all users with appropriate attributes based on user role.
  # Allows sorting and filtering by name.
  #
  # @return [void]
  def index
    @attributes = if current_user.admin?
                    ADMIN_ACCESS_ATTRIBUTES
                  elsif current_user.officer?
                    OFFICER_ACCESS_ATTRIBUTES
                  else
                    USER_ACCESS_ATTRIBUTES
                  end

    # Combine user-selected attributes with allowed attributes
    select_attributes_param = params[:select_attributes]&.map(&:to_sym) || INITIAL_SELECT_ATTRIBUTES
    @select_attributes = select_attributes_param & @attributes
    @users = User.all

    # Apply sorting and filtering
    @users = @users.order("#{params[:sort]} #{params[:direction]}") if params[:sort].present?
    @users = @users.where('full_name LIKE ?', "%#{params[:search]}%") if params[:search].present?
  end

  # GET /users/1 or /users/1.json
  # Displays a specific user with associated projects and attributes based on role.
  #
  # @return [void]
  def show
    @attributes = if current_user.admin? || current_user.id == @user.id
                    ADMIN_ACCESS_ATTRIBUTES
                  elsif current_user.officer?
                    OFFICER_ACCESS_ATTRIBUTES
                  else
                    USER_ACCESS_ATTRIBUTES
                  end
    @projects = @user.projects
  end

  # GET /users/new
  # Initializes a new user for creation. Requires officer-level permissions.
  #
  # @return [void]
  def new
    return unless require_officer
    @user = User.new
  end

  # GET /users/1/edit
  # Provides form for editing a user. Restricts access based on role.
  #
  # @return [void]
  def edit
    redirect_to root_path unless current_user.officer? || current_user.admin? || current_user.id == @user.id
  end

  # POST /users or /users.json
  # Creates a new user with a complete account status. Requires officer-level permissions.
  #
  # @return [void]
  def create
    return unless require_officer
    @projects = []
    @user = User.new(user_params)
    @user.account_complete = true

    if @user.valid?
      save_user(@user, :new)
    else
      render_errors(@user.errors, :new)
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  # Updates a user's profile. Requires officer-level permissions or user ownership.
  # Validates LinkedIn URL format.
  #
  # @return [void]
  def update
    return unless current_user.id == @user.id || require_officer
    @projects = []

    if !valid_linkedin_url?(user_params[:linkedin_url])
      flash[:alert] = 'LinkedIn URL must be a valid LinkedIn profile URL.'
    elsif @user.update(user_params.merge(linkedin_url: process_linkedin_url(user_params[:linkedin_url])))
      save_user(@user, :edit)
    else
      render_errors(@user.errors, :edit)
    end
  end

  # DELETE /users/1 or /users/1.json
  # Permanently deletes a user. Requires officer-level permissions.
  #
  # @return [void]
  def destroy
    return unless require_officer
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /users/complete_profile
  # Displays the form for completing the user's profile.
  #
  # @return [void]
  def complete_profile
    @user = current_user
  end

  # PATCH/PUT /users/update_profile
  # Updates the user's profile and sets account to complete. Validates LinkedIn URL format.
  #
  # @return [void]
  def update_profile
    @user = current_user

    if user_params.values.any?(&:blank?)
      flash[:alert] = 'All fields must be filled out.'
      render :complete_profile
    elsif !valid_linkedin_url?(user_params[:linkedin_url])
      flash[:alert] = 'LinkedIn URL must be a valid LinkedIn profile URL.'
      render :complete_profile
    elsif @user.update(user_params.merge(linkedin_url: process_linkedin_url(user_params[:linkedin_url])))
      @user.update(account_complete: true)
      redirect_to root_path, notice: 'Profile updated successfully.'
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :complete_profile
    end
  end

  # GET /users/csv
  # Exports user data to CSV format. Requires officer-level permissions.
  #
  # @return [void]
  def csv
    return unless require_officer
    csv_data = User.to_csv %w[full_name email user_type phone_number class_year ring_date grad_date birthday
                              shirt_size dietary_restriction account_complete created_at updated_at linkedin_url]
    send_data csv_data, filename: "users-#{Date.today}.csv", type: 'text/csv'
  end

  private

  # Finds and sets the user object based on the id parameter.
  #
  # @return [void]
  def set_user
    @user = User.find(params[:id])
  end

  # Loads all projects and assigns them to @projects for selection in forms.
  #
  # @return [void]
  def set_projects
    @projects = Project.all
  end

  # Defines and permits the allowed parameters for creating/updating a user.
  #
  # @return [ActionController::Parameters] Filtered parameters for user creation/update
  def user_params
    if action_name == 'update_profile'
      params.require(:user).permit(:phone_number, :class_year, :ring_date, :grad_date, :birthday, :shirt_size,
                                   :dietary_restriction, :linkedin_url)
    else
      params.require(:user).permit(:email, :full_name, :uid, :avatar_url, :user_type, :phone_number, :class_year,
                                   :ring_date, :grad_date, :birthday, :shirt_size, :dietary_restriction, :linkedin_url, project_ids: [])
    end
  end

  # Saves the user and renders appropriate response based on success.
  #
  # @param user [User] The user to be saved
  # @param action [Symbol] The action to render on failure
  # @return [void]
  def save_user(user, action)
    respond_to do |format|
      if user.save
        format.html { redirect_to user_url(user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: user }
      else
        format.html { render action, status: :unprocessable_entity }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Renders errors and appropriate response based on failure.
  #
  # @param errors [ActiveModel::Errors] Errors from the user object
  # @param action [Symbol] The action to render on failure
  # @return [void]
  def render_errors(errors, action)
    respond_to do |format|
      format.html { render action, status: :unprocessable_entity }
      format.json { render json: errors, status: :unprocessable_entity }
    end
  end

  # Validates if the LinkedIn URL is in a proper LinkedIn profile format.
  #
  # @param url [String] The LinkedIn URL to validate
  # @return [Boolean] True if the URL is valid, false otherwise
  def valid_linkedin_url?(url)
    uri = URI.parse(url) rescue nil
    uri&.host&.include?('linkedin.com') && uri.path.start_with?('/in/')
  end

  # Extracts the unique profile postfix from the LinkedIn URL.
  #
  # @param url [String] The LinkedIn URL to process
  # @return [String] The unique postfix for the LinkedIn profile
  def process_linkedin_url(url)
    URI.parse(url).path.split('/in/').last
  end
end
