class EmailsController < AdminApplicationController
  def email
    @users = User.all
  end

  def send_email
    recipients = params[:recipients].split(',')
    subject = params[:subject]
    message = params[:message]
    AdminMailer.blast_email(recipients, subject, message).deliver_now
    redirect_to email_path, notice: 'Email sent successfully.'
  end
end
