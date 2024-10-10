# frozen_string_literal: true

class UsersController < AuthenticatedApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_attributes, only: %i[index show]

  # GET /users or /users.json
  def index
    @users = User.all

    # Sorting
    @users = @users.order("#{params[:sort]} #{params[:direction]}") if params[:sort].present?

    # Filtering
    if params[:search].present?
      @users = @users.where("full_name LIKE ?", "%#{params[:search]}%")
    end
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    return unless require_admin

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
    return unless require_admin

    if @user.update(user_params)
      save_user(@user, :edit)
    else
      render_errors(@user.errors, :edit)
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    return unless require_admin

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
    elsif @user.update(user_params)
      @user.update(account_complete: true)
      redirect_to root_path, notice: 'Profile updated successfully.'
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :complete_profile
    end
  end  

  private

  def set_attributes
    @attributes = if current_user.admin?
                    %i[email full_name user_type phone_number class_year ring_date grad_date birthday
                       shirt_size dietary_restriction account_complete created_at updated_at]
                  else
                    %i[email full_name user_type]
                  end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    if action_name == 'update_profile'
      params.require(:user).permit(:phone_number, :class_year, :ring_date, :grad_date, :birthday, :shirt_size, :dietary_restriction)
    else
      params.require(:user).permit(:email, :full_name, :uid, :avatar_url, :user_type, :phone_number, :class_year, :ring_date, :grad_date, :birthday, :shirt_size, :dietary_restriction)
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
end
