# frozen_string_literal: true

class AdminMailerPreview < ActionMailer::Preview
  def blast_email
    recipients = ['test1@email.com', 'test2@email.com', 'test3@email.com']
    subject = 'Test Email'
    message = 'This is a test email.'
    AdminMailer.blast_email(recipients, subject, message)
  end
end
