class AdminMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: 'rhinopav@gmail.com', subject: 'Welcome to EWB')
  end
end
