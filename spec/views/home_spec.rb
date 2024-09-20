# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homepage', type: :view do
  it 'displays the correct header' do
    render template: 'pages/home'
    expect(rendered).to include('Engineers Without Borders')
    expect(rendered).to include('Texas A&M University')
  end
end
