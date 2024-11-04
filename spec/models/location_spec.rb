require 'rails_helper'

RSpec.describe Location, type: :model do
    subject do
        described_class.new(address: '125 Spence St', city: 'College Station', state: 'Texas', zip_code: '77843', country: 'United States of America')
    end

    it 'is valid with all valid attributes' do
        expect(subject).to be_valid
    end

    it 'is not valid without an address' do
        subject.address = nil
        expect(subject).not_to be_valid
    end

    it 'is not valid without a city' do
        subject.city = nil
        expect(subject).not_to be_valid
    end

    it 'is not valid without a state' do
        subject.state = nil
        expect(subject).not_to be_valid
    end

    it 'is not valid without a zip code' do
        subject.zip_code = nil
        expect(subject).not_to be_valid
    end

    it 'is not valid with invalid characters in zip code' do
        subject.zip_code = '<>'
        expect(subject).not_to be_valid
    end

    it 'is not valid without a country' do
        subject.country = nil
        expect(subject).not_to be_valid
    end
end