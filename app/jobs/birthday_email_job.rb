# frozen_string_literal: true

class BirthdayEmailJob < ApplicationJob
  queue_as :default

  def perform
    @people = User.where('extract(month from birthday) = ? AND extract(day from birthday) = ?', Date.today.month,
                         Date.today.day)
    @people.each do |person|
      AdminMailer.birthday_email(person).deliver_now
    end
  end
end
