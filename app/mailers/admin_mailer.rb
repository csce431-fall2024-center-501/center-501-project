class AdminMailer < ApplicationMailer
  def individual_email(recipients, subject, message)
    @message = message
    mail(to: recipients, subject:)
  end

  def active_member_email(subject, message)
    @message = message
    @users = User.where('grad_date > ?', Date.today)
    @users.find_in_batches(batch_size: 50) do |group|
      mail(to: group.pluck(:email), subject:) if group.present?
    end
  end

  def active_inactive_member_email(subject, message)
    @message = message
    @users = User.all
    @users.find_in_batches(batch_size: 50) do |group|
      mail(to: group.pluck(:email), subject:) if group.present?
    end
  end

  def birthday_email(person)
    @person = person
    mail(to: @person.email, subject: "Happy Birthday #{person.full_name}!")
  end

  def calendar_email(subject, event_list)
    @users = User.where('grad_date > ?', Date.today)
    @event_list = event_list
    @users.find_in_batches(batch_size: 50) do |group|
      mail(to: group.pluck(:email), subject:) if group.present?
    end
  end
end
