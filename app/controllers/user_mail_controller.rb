class UserMailController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.with(user: @user).welcome_email.deliver_now
      redirect_to root_path
    else
      render :new
    end
  end
end
