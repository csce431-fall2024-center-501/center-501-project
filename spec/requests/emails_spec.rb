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
      allow(AdminMailer).to receive_message_chain(:indiviual_email, :deliver_now)
    end

    it 'sends an email to the specified recipients' do
      post send_email_path, params: { recipients:, subject:, message: }
      expect(AdminMailer).to have_received(:indiviual_email).with(['test1@example.com', 'test2@example.com'], subject,
                                                                  message)
    end

    it 'redirects to the email path with a success notice' do
      post send_email_path, params: { recipients:, subject:, message: }
      expect(response).to redirect_to(email_path)
    end
  end

  describe 'POST /emails/send_active_member_email' do
    include TestAttributes

    let(:subject) { 'Test Subject' }
    let(:message) { 'Test Message' }

    before do
      sign_in User.create!(valid_admin_attributes)
      allow(AdminMailer).to receive_message_chain(:active_member_email, :deliver_now)
    end

    it 'sends an email to all active members' do
      post send_active_member_email_path, params: { subject:, message: }
      expect(AdminMailer).to have_received(:active_member_email).with(subject, message)
    end

    it 'redirects to the email path with a success notice' do
      post send_active_member_email_path, params: { subject:, message: }
      expect(response).to redirect_to(email_path)
    end
  end

  describe 'POST /emails/send_active_inactive_member_email' do
    include TestAttributes

    let(:subject) { 'Test Subject' }
    let(:message) { 'Test Message' }

    before do
      sign_in User.create!(valid_admin_attributes)
      allow(AdminMailer).to receive_message_chain(:active_inactive_member_email, :deliver_now)
    end

    it 'sends an email to all active and inactive members' do
      post send_active_inactive_member_email_path, params: { subject:, message: }
      expect(AdminMailer).to have_received(:active_inactive_member_email).with(subject, message)
    end

    it 'redirects to the email path with a success notice' do
      post send_active_inactive_member_email_path, params: { subject:, message: }
      expect(response).to redirect_to(email_path)
    end
  end

  describe 'GET /emails/individual_email' do
    include TestAttributes

    before do
      sign_in User.create!(valid_admin_attributes)
    end

    it 'renders the individual_email template' do
      get individual_email_path
      expect(response).to render_template(:individual_email)
    end

    it 'assigns all users to @users' do
      get individual_email_path
      expect(assigns(:users)).to eq(User.all)
    end
  end

  describe 'GET /emails/active_member_email' do
    include TestAttributes

    before do
      sign_in User.create!(valid_admin_attributes)
    end

    it 'renders the active_member_email template' do
      get active_member_email_path
      expect(response).to render_template(:active_member_email)
    end
  end

  describe 'GET /emails/active_inactive_member_email' do
    include TestAttributes

    before do
      sign_in User.create!(valid_admin_attributes)
    end

    it 'renders the active_inactive_member_email template' do
      get active_inactive_member_email_path
      expect(response).to render_template(:active_inactive_member_email)
    end
  end

  describe 'GET /emails/email' do
    include TestAttributes

    before do
      sign_in User.create!(valid_admin_attributes)
    end

    it 'renders the email template' do
      get email_path
      expect(response).to render_template(:email)
    end
  end
end
