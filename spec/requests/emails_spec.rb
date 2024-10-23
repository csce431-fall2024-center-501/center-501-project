# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Emails', type: :request do
  describe 'POST /emails/send_email' do
    include TestAttributes

    let(:recipients) { 'test1@example.com,test2@example.com' }
    let(:subject) { 'Test Subject' }
    let(:message) { 'Test Message' }

    before do
      sign_in User.create!(valid_admin_attributes)
      allow(AdminMailer).to receive_message_chain(:blast_email, :deliver_now)
    end

    it 'sends an email to the specified recipients' do
      post send_email_path, params: { recipients: recipients, subject: subject, message: message }
      expect(AdminMailer).to have_received(:blast_email).with(['test1@example.com', 'test2@example.com'], subject, message)
    end

    it 'redirects to the email path with a success notice' do
      post send_email_path, params: { recipients: recipients, subject: subject, message: message }
      expect(response).to redirect_to(email_path)
    end
  end
end
