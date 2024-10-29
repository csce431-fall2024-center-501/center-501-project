# frozen_string_literal: true

class EmailsController < AdminApplicationController
  def individual_email
    @users = User.all
  end

  def active_member_email
    @users = User.where('grad_date > ?', Date.today)
  end

  def active_inactive_member_email
    @users = User.all
  end

  def send_email
    recipients = params[:recipients].split(',')
    subject = params[:subject]
    message = params[:message]
    AdminMailer.indiviual_email(recipients, subject, message).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
  end

  def send_active_member_email
    subject = params[:subject]
    message = params[:message]
    AdminMailer.active_member_email(subject, message).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
  end

  def send_active_inactive_member_email
    subject = params[:subject]
    message = params[:message]
    AdminMailer.active_inactive_member_email(subject, message).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
  end
end
