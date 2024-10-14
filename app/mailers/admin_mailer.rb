class AdminMailer < ApplicationMailer
  def blast_email(recipients, subject, message)
    @message = message
    mail(to: recipients, subject:)
  end
end
