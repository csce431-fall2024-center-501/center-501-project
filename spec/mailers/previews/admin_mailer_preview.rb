# frozen_string_literal: true

class AdminMailerPreview < ActionMailer::Preview
  def individual_email
    recipients = ['test1@email.com', 'test2@email.com', 'test3@email.com']
    subject = 'Test Email'
    message = 'This is a test email.'
    AdminMailer.individual_email(recipients, subject, message)
  end

  def active_member_email
    subject = 'Test Active Member Blast Email'
    message = 'This is a test active member blast email.'
    AdminMailer.active_member_email(subject, message)
  end

  def active_inactive_member_email
    subject = 'Test Active and Inactive Member Blast Email'
    message = 'This is a test active and inactive member blast email.'
    AdminMailer.active_inactive_member_email(subject, message)
  end
end
