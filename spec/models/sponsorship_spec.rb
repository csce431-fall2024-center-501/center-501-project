# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sponsorship, type: :model do
  subject do
    described_class.new(sponsor_name: 'Rich Sponsor', sponsor_lead_name: 'Rich Lead', sponsor_phone: '9791234567',
                        sponsor_email: 'rich@gmail.com', sponsor_donation: 188.80, sponsor_end_of_contract: '2025-12-31')
  end

  it 'is valid with all valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a sponsor name' do
    subject.sponsor_name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a sponsor lead name' do
    subject.sponsor_lead_name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a sponsor phone' do
    subject.sponsor_phone = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a sponsor email' do
    subject.sponsor_email = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a sponsor donation' do
    subject.sponsor_donation = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with a non-numerical sponsor donation' do
    subject.sponsor_donation = 'hundred dollars'
    expect(subject).not_to be_valid
  end

  it 'is not valid with a negative sponsor donation' do
    subject.sponsor_donation = -1
    expect(subject).not_to be_valid
  end

  it 'is not valid without a sponsor end of contract' do
    subject.sponsor_end_of_contract = nil
    expect(subject).not_to be_valid
  end
end
