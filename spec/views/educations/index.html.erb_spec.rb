# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'educations/index', type: :view do
  before(:each) do
    assign(:educations, [
             Education.create!(
               educationName: 'Education Name',
               educationType: 'Education Type',
               educationDescription: 'Education Description'
             ),
             Education.create!(
               educationName: 'Education Name',
               educationType: 'Education Type',
               educationDescription: 'Education Description'
             )
           ])
  end

  it 'renders a list of educations' do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new('Education Name'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Education Type'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Education Description'.to_s), count: 2
  end
end
