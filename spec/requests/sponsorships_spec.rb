# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sponsorships', type: :request do
  include TestAttributes
  include RequestHelpers
  let(:valid_sponsor_attributes) do
    {
      sponsor_name: 'Rich Sponsor',
      sponsor_lead_name: 'Rich Lead',
      sponsor_phone: '9791234567',
      sponsor_email: 'rich@gmail.com',
      sponsor_donation: 188.80,
      sponsor_end_of_contract: '2025-12-31'
    }
  end

  let(:invalid_sponsor_attributes) do
    {
      sponsor_name: ''
    }
  end

  describe 'GET /index' do
    context 'when regular user is logged in' do
      let(:user) { User.create!(valid_attributes) }

      before do
        sign_in user
      end
      it 'returns http success' do
        get sponsorships_path
        expect(response).to have_http_status(:success)
      end

      it 'displays a list of sponsorships' do
        Sponsorship.create!(valid_sponsor_attributes)
        get sponsorships_path
        expect(response.body).to include('Rich Sponsor')
      end
    end
  end

  describe 'GET /new' do
    context 'when officer is logged in' do
      let(:officer) { User.create!(valid_officer_attributes) }

      before do
        sign_in officer
      end
      it 'returns http success' do
        get new_sponsorship_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'when regular user is logged in' do
      let(:user) { User.create!(valid_attributes) }

      before do
        sign_in user
      end
      it 'redirects to the root path' do
        test_redirect_to_root(new_sponsorship_path, nil)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters and officer logged in' do
      let(:officer) { User.create!(valid_officer_attributes) }

      before do
        sign_in officer
      end
      it 'creates a new sponsorship' do
        expect do
          post sponsorships_path, params: { sponsorship: valid_sponsor_attributes }
        end.to change(Sponsorship, :count).by(1)
      end

      it 'redirects to the sponsorships list' do
        post sponsorships_path, params: { sponsorship: valid_sponsor_attributes }
        expect(response).to redirect_to(sponsorships_path)
        expect(flash[:notice]).to eq('Sponsorship record was successfully created.')
      end
    end

    context 'with invalid parameters and officer logged in' do
      let(:officer) { User.create!(valid_officer_attributes) }

      before do
        sign_in officer
      end
      it 'does not create a new sponsorship' do
        expect do
          post sponsorships_path, params: { sponsorship: invalid_sponsor_attributes }
        end.to change(Sponsorship, :count).by(0)
      end

      it 'renders the new template' do
        post sponsorships_path, params: { sponsorship: invalid_sponsor_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /show' do
    context 'when regular user is logged in' do
      let(:user) { User.create!(valid_attributes) }

      before do
        sign_in user
      end
      let!(:sponsorship) { Sponsorship.create!(valid_sponsor_attributes) }

      it 'returns http success' do
        get sponsorship_path(sponsorship)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /edit' do
    context 'when officer is logged in' do
      let(:officer) { User.create!(valid_officer_attributes) }

      before do
        sign_in officer
      end
      let!(:sponsorship) { Sponsorship.create!(valid_sponsor_attributes) }

      it 'returns http success' do
        get edit_sponsorship_path(sponsorship)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when regular user is logged in' do
      let(:user) { User.create!(valid_attributes) }

      before do
        sign_in user
      end
      let!(:sponsorship) { Sponsorship.create!(valid_sponsor_attributes) }
      it 'redirects to the root path' do
        test_redirect_to_root(edit_sponsorship_path(sponsorship), nil)
      end
    end
  end

  describe 'GET /delete' do
    context 'when officer is logged in' do
      let(:officer) { User.create!(valid_officer_attributes) }

      before do
        sign_in officer
      end

      let!(:sponsorship) { Sponsorship.create!(valid_sponsor_attributes) }
      it 'returns http success' do
        get delete_sponsorship_path(sponsorship)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when regular user is logged in' do
      let(:user) { User.create!(valid_attributes) }

      before do
        sign_in user
      end

      let!(:sponsorship) { Sponsorship.create!(valid_sponsor_attributes) }
      it 'redirects to the root path' do
        test_redirect_to_root(delete_sponsorship_path(sponsorship), nil)
      end
    end
  end


  describe 'PATCH /update' do
    let!(:sponsorship) { Sponsorship.create!(valid_sponsor_attributes) }

    context 'with valid parameters and officer logged in' do
      let(:officer) { User.create!(valid_officer_attributes) }

      before do
        sign_in officer
      end
      it 'updates the sponsorship' do
        patch sponsorship_path(sponsorship), params: { sponsorship: { sponsor_name: 'Updated Sponsor' } }
        sponsorship.reload
        expect(sponsorship.sponsor_name).to eq('Updated Sponsor')
      end

      it 'redirects to the sponsorships list' do
        patch sponsorship_path(sponsorship), params: { sponsorship: { sponsor_name: 'Updated Sponsor' } }
        expect(response).to redirect_to(sponsorships_path)
        expect(flash[:notice]).to eq('Sponsorship record was successfully updated.')
      end
    end

    context 'with invalid parameters and officer logged in' do
      let(:officer) { User.create!(valid_officer_attributes) }

      before do
        sign_in officer
      end
      it 'does not update the sponsorship' do
        patch sponsorship_path(sponsorship), params: { sponsorship: invalid_sponsor_attributes }
        expect(sponsorship.sponsor_name).to_not eq('')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when officer is logged in' do
      let(:officer) { User.create!(valid_officer_attributes) }

      before do
        sign_in officer
      end
      let!(:sponsorship) { Sponsorship.create!(valid_sponsor_attributes) }

      it 'destroys the sponsorship' do
        expect do
          delete sponsorship_path(sponsorship)
        end.to change(Sponsorship, :count).by(-1)
      end

      it 'redirects to the sponsorships list' do
        delete sponsorship_path(sponsorship)
        expect(response).to redirect_to(sponsorships_path)
      end
    end
  end
end
