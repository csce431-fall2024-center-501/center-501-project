class AdminMailer < ApplicationMailer
  def indiviual_email(recipients, subject, message)
    @message = message
    mail(to: recipients, subject:)
  end

  def active_member_email(subject, message)
    @message = message
    @users = User.where('graduation_date > ?', Date.today)
    mail(to: @users.pluck(:email), subject:)
  end

  def active_inactive_member_email(subject, message)
    @message = message
    @users = User.all
    mail(to: @users.pluck(:email), subject:)
  end
end
