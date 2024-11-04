namespace :birthday_email do
  desc 'Send birthday emails'
  task send: :environment do
    BirthdayEmailJob.perform_now
  end
end