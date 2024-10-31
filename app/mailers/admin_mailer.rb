class AdminMailer < ApplicationMailer
  def indiviual_email(recipients, subject, message)
    @message = message
    mail(to: recipients, subject:)
  end

  def active_member_email(subject, message)
    @message = message
    @users = User.where('grad_date > ?', Date.today)
    mail(to: @users.pluck(:email), subject:) if @users.present?
  end

  def active_inactive_member_email(subject, message)
    @message = message
    @users = User.all
    mail(to: @users.pluck(:email), subject:) if @users.present?
  end

  def birthday_email(person)
    @person = person
    mail(to: @person.pluck(:email), subject: "Happy Birthday#{person.full_name}!") if @users.present?
  end

  def calendar_email(subject, event_list)
    @users = User.where('grad_date > ?', Date.today)
    @event_list = event_list
    mail(to: @users.pluck(:email), subject:) if @users.present?
  end
end
