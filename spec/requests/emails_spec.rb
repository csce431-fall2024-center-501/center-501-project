# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailsController, type: :controller do
  describe 'POST #send_email' do
    let(:recipients) { 'test1@example.com,test2@example.com' }
    let(:subject) { 'Test Subject' }
    let(:message) { 'Test Message' }

    before do
      allow(AdminMailer).to receive_message_chain(:blast_email, :deliver_now)
    end

    it 'sends an email to the specified recipients' do
      post :send_email, params: { recipients:, subject:, message: }
      expect(AdminMailer).to have_received(:blast_email).with(['test1@example.com', 'test2@example.com'], subject,
                                                              message)
    end

    it 'redirects to the email path with a success notice' do
      post :send_email, params: { recipients:, subject:, message: }
      expect(response).to redirect_to(email_path)
      expect(flash[:notice]).to eq('Email sent successfully.')
    end
  end
end
