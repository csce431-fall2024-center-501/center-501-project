require 'rails_helper'

RSpec.describe Photo, type: :model do
  include TestAttributes
  describe 'validations' do
    it 'is valid with valid attributes' do
      photo = Photo.new(description: 'Sample description', url: 'https://example.com/photo.jpg')
      expect(photo).to be_valid
    end

    it 'is invalid without a description' do
      photo = Photo.new(url: 'https://example.com/photo.jpg')
      expect(photo).to be_invalid
      expect(photo.errors[:description]).to include("can't be blank")
    end

    it 'is invalid without a url' do
      photo = Photo.new(description: 'Sample description')
      expect(photo).to be_invalid
      expect(photo.errors[:url]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'can belong to a project' do
      project = Project.create!(valid_project_attributes)
      photo = Photo.new(description: 'Sample description', url: 'https://example.com/photo.jpg', project: project)
      expect(photo.project).to eq(project)
      expect(photo).to be_valid
    end

    it 'is valid without a project' do
      photo = Photo.new(description: 'Sample description', url: 'https://example.com/photo.jpg')
      expect(photo.project).to be_nil
      expect(photo).to be_valid
    end
  end
end
