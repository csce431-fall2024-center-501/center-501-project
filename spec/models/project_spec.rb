# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'has a name' do
    @project = Project.new(
      projectName: '',
      projectDesc: 'This is a test project.',
      projectStartDate: Date.today,
      locationID: 100,
      isProjectActive: true
    )

    expect(@project.projectName).to be_empty
    @project.projectName = 'Test Project'
    expect(@project).to be_valid
  end

  it 'has a description' do
    @project = Project.new(
      projectName: 'Test Project',
      projectDesc: '',
      projectStartDate: Date.today,
      locationID: 100,
      isProjectActive: true
    )

    expect(@project.projectDesc).to be_empty
    @project.projectDesc = 'This is a test project.'
    expect(@project).to be_valid
  end

  it 'has a start date' do
    @project = Project.new(
      projectName: 'Test Project',
      projectDesc: 'This is a test project.',
      projectStartDate: nil,
      locationID: 100,
      isProjectActive: true
    )

    expect(@project.projectStartDate).to be_nil
    @project.projectStartDate = Date.today
    expect(@project).to be_valid
  end

  it 'has a location' do
    @project = Project.new(
      projectName: 'Test Project',
      projectDesc: 'This is a test project.',
      projectStartDate: Date.today,
      locationID: 0,
      isProjectActive: true
    )

    expect(@project.locationID).to eq(0)
    @project.locationID = 100
    expect(@project).to be_valid
  end
end
