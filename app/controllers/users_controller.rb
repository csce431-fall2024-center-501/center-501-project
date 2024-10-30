# frozen_string_literal: true

class UsersController < AuthenticatedApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_projects, only: %i[edit new]
  
  # Only attributes that are selected by default
  INITIAL_SELECT_ATTRIBUTES = %i[full_name email phone_number class_year linkedin_url].freeze

  # Attributes that admins can access
  ADMIN_ACCESS_ATTRIBUTES = %i[full_name email user_type phone_number class_year ring_date grad_date birthday
                               shirt_size dietary_restriction account_complete created_at updated_at linkedin_url].freeze

  # Attributes that officers can access
  OFFICER_ACCESS_ATTRIBUTES = %i[full_name email user_type phone_number class_year ring_date grad_date birthday
                                 shirt_size dietary_restriction account_complete created_at updated_at linkedin_u].freeze

  # Attributes that users can access
  USER_ACCESS_ATTRIBUTES = %i[full_name email phone_number class_year linkedin_url].freeze

  # GET /users or /users.json
  def index
    @attributes = if current_user.admin?
                    ADMIN_ACCESS_ATTRIBUTES
                  elsif current_user.officer?
                    OFFICER_ACCESS_ATTRIBUTES
                  else
                    USER_ACCESS_ATTRIBUTES
                  end

    # Convert params[:select_attributes] to an array of symbols if it's present
    select_attributes_param = if params[:select_attributes].present?
                                params[:select_attributes].map(&:to_sym)
                              else
                                INITIAL_SELECT_ATTRIBUTES
                              end

    # Combine user-selected attributes with allowed attributes
    @select_attributes = select_attributes_param & @attributes

    @users = User.all

    # Sorting
    @users = @users.order("#{params[:sort]} #{params[:direction]}") if params[:sort].present?

    # Filtering
    return unless params[:search].present?

    @users = @users.where('full_name LIKE ?', "%#{params[:search]}%")
  end

  # GET /users/1 or /users/1.json
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
  def new
    return unless require_officer
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if !(current_user.officer? || current_user.admin? || current_user.id == @user.id)
      redirect_to root_path
    end
  end

  # POST /users or /users.json
  def create
    @projects = []
    return unless require_officer

    @user = User.new(user_params)
    @user.account_complete = true

    if @user.valid?
      save_user(@user, :new)
    else
      render_errors(@user.errors, :new)
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @projects = []
    return unless current_user.id == @user.id || require_officer

    if @user.update(user_params)
      save_user(@user, :edit)
    else
      render_errors(@user.errors, :edit)
    end
  end

  def delete
    return unless require_officer

    @user = User.find(params[:id])
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    return unless require_officer

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /users/complete_profile
  def complete_profile
    @user = current_user
  end

  # PATCH/PUT /users/update_profile
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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_projects
    @projects = Project.all
  end

  def user_params
    if action_name == 'update_profile'
      params.require(:user).permit(:phone_number, :class_year, :ring_date, :grad_date, :birthday, :shirt_size,
                                   :dietary_restriction, :linkedin_url)
    else
      params.require(:user).permit(:email, :full_name, :uid, :avatar_url, :user_type, :phone_number, :class_year,
                                   :ring_date, :grad_date, :birthday, :shirt_size, :dietary_restriction, :linkedin_url, project_ids: [])
    end
  end

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

  def render_errors(errors, action)
    respond_to do |format|
      format.html { render action, status: :unprocessable_entity }
      format.json { render json: errors, status: :unprocessable_entity }
    end
  end

  # Validation function to check if the LinkedIn URL is valid
  def valid_linkedin_url?(url)
    uri = begin
      URI.parse(url)
    rescue StandardError
      nil
    end
    uri && uri.host&.include?('linkedin.com') && uri.path.start_with?('/in/')
  end

  # Processor function to extract the unique postfix from the LinkedIn URL
  def process_linkedin_url(url)
    uri = URI.parse(url)
    uri.path.split('/in/').last
  end
end
