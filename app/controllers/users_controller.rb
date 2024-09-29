# frozen_string_literal: true

class UsersController < AuthenticatedApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_attributes, only: [:index, :show]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
  end
  

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    return unless require_admin

    # if user is not admin, do not create user
    # TODO ability to edit your own user profile even if not admin
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    return unless require_admin

    # if user is not admin, do not edit user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    return unless require_admin

    # if user is not admin, do not delete user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def complete_profile; end

  def update_profile
    @user = current_user

    if user_params.values.any?(&:blank?)
      flash[:alert] = 'All fields must be filled out.'
      render :complete_profile
      return
    end

    processed_params = user_params.dup

    begin
      processed_params[:ring_date] = Date.new(
        params["ring_date(1i)"].to_i,
        params["ring_date(2i)"].to_i,
        params["ring_date(3i)"].to_i
      )
      processed_params[:grad_date] = Date.new(
        params["grad_date(1i)"].to_i,
        params["grad_date(2i)"].to_i,
        params["grad_date(3i)"].to_i
      )
      processed_params[:birthday] = Date.new(
        params["birthday(1i)"].to_i,
        params["birthday(2i)"].to_i,
        params["birthday(3i)"].to_i
      )
    rescue ArgumentError
      flash[:alert] = 'Invalid date provided.'
      render :complete_profile
      return
    end

    if @user.update(processed_params)
      @user.update(account_complete: true)
      redirect_to root_path, notice: 'Profile updated successfully.'
    else
      render :complete_profile
    end
  end

  private

  def set_attributes
    if current_user.admin?
      @attributes = [
        :email, :full_name, :user_type, :uid, :phone_number, :class_year, 
        :ring_date, :grad_date, :birthday, :shirt_size, :dietary_restriction, 
        :account_complete, :created_at, :updated_at
      ]
    else
      @attributes = [:email, :full_name, :user_type]
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    if action_name == 'update_profile'
      params.require(:user).permit(:phone_number, :class_year, :ring_date, :grad_date, :birthday, :shirt_size, :dietary_restriction)
    else
      params.require(:user).permit(:email, :full_name, :uid, :avatar_url, :user_type)
    end
  end
end
