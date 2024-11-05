# UserMailController handles user-related email actions, such as sending a welcome email.
class UserMailController < ApplicationController
  # POST /user_mail
  # Creates a new user record and sends a welcome email upon successful save.
  #
  # @return [void]
  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.with(user: @user).welcome_email.deliver_now
      redirect_to root_path
    else
      render :new
    end
  end

  private

  # Defines and permits the allowed parameters for creating a user.
  #
  # @return [ActionController::Parameters] Filtered parameters for user creation
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
