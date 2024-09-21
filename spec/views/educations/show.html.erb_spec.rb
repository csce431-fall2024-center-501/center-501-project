# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'educations/show', type: :view do
  before(:each) do
    assign(:education, Education.create!(
                         educationName: 'Education Name',
                         educationType: 'Education Type',
                         educationDescription: 'Education Description'
                       ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Education Name/)
    expect(rendered).to match(/Education Type/)
    expect(rendered).to match(/Education Description/)
  end
end
