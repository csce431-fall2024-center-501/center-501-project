require 'rails_helper'

# TODO - add tests verifying no action is allowed when user is not logged in or not an officer

RSpec.describe PhotosController, type: :request do
  include TestAttributes

  describe "GET /index" do
    it "renders a successful response with expected information when officer" do
      sign_in User.create! valid_officer_attributes
      Photo.create!(valid_photo_attributes1)
      Photo.create!(valid_photo_attributes2)
      get photos_url
      expect(response).to be_successful
      expect(response.body).to include(valid_photo_attributes1[:description])
      expect(response.body).to include(valid_project_attributes[:projectName])
      expect(response.body).to include(valid_photo_attributes2[:description])
    end
  end

  describe "GET /show" do
    it "renders a successful response with expected information when officer" do
      sign_in User.create! valid_officer_attributes
      photo = Photo.create!(valid_photo_attributes1)
      Photo.create!(valid_photo_attributes2)
      get photo_url(photo)
      expect(response).to be_successful
      expect(response.body).to include(valid_photo_attributes1[:description])
      expect(response.body).to include(valid_project_attributes[:projectName])
      expect(response.body).not_to include(valid_photo_attributes2[:description])
    end
  end

  describe "GET /new" do
    it "renders a successful response with expected information when officer" do
      sign_in User.create! valid_officer_attributes
      Project.create(valid_project_attributes)
      Project.create(valid_project_attributes2)
      get new_photo_url
      expect(response).to be_successful
      expect(response.body).to include(valid_project_attributes[:projectName])
      expect(response.body).to include(valid_project_attributes2[:projectName])
    end
  end

  describe "GET /edit" do
    it "renders a successful response with expected information" do
      sign_in User.create! valid_officer_attributes
      photo = Photo.create!(valid_photo_attributes1)
      Photo.create!(valid_photo_attributes2)
      get edit_photo_url(photo)
      expect(response).to be_successful
      expect(response.body).to include(valid_photo_attributes1[:description])
      expect(response.body).to include(valid_project_attributes[:projectName])
      expect(response.body).not_to include(valid_photo_attributes2[:description])
    end
  end

  describe "POST /create" do
    context "with valid parameters and atleast officer" do
      before do
        sign_in User.create! valid_officer_attributes
      end

      it "creates a new Photo" do
        expect {
          post photos_url, params: { photo: valid_photo_attributes1 }
        }.to change(Photo, :count).by(1)
      end

      it "redirects to the created photo" do
        post photos_url, params: { photo: valid_photo_attributes1 }
        expect(response).to redirect_to(photo_url(Photo.last))
      end
    end

    context "with invalid parameters and atleast officer" do
      before do
        sign_in User.create! valid_officer_attributes
      end

      it "does not create a new Photo" do
        expect {
          post photos_url, params: { photo: invalid_photo_attributes }
        }.not_to change(Photo, :count)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters and officer logged in" do
      before do
        sign_in User.create! valid_officer_attributes
      end
      let(:new_attributes) do
        { description: 'Updated description' }
      end

      it "updates the requested photo" do
        photo = Photo.create!(valid_photo_attributes1)
        patch photo_url(photo), params: { photo: new_attributes }
        photo.reload
        expect(photo.description).to eq('Updated description')
      end

      it "redirects to the photo" do
        photo = Photo.create!(valid_photo_attributes1)
        patch photo_url(photo), params: { photo: new_attributes }
        expect(response).to redirect_to(photo_url(photo))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e., to display the 'edit' template)" do
        sign_in User.create! valid_officer_attributes
        photo = Photo.create!(valid_photo_attributes1)
        patch photo_url(photo), params: { photo: invalid_photo_attributes }
        expect(photo.description).to eq(valid_photo_attributes1[:description])
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested photo when officer" do
      sign_in User.create! valid_officer_attributes
      photo = Photo.create!(valid_photo_attributes1)
      expect {
        delete photo_url(photo)
      }.to change(Photo, :count).by(-1)
    end

    it "redirects to the photos list" do
      sign_in User.create! valid_officer_attributes
      photo = Photo.create!(valid_photo_attributes1)
      delete photo_url(photo)
      expect(response).to redirect_to(photos_url)
    end
  end
end
