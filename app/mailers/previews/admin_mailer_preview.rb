class AdminMailerPreview < ActionMailer::Preview
  def welcome_email
    user1 = User.new(name: 'John Doe', email: 'joe@gmail.com')
    AdminMailer.with(user: user1).welcome_email
  end
end
