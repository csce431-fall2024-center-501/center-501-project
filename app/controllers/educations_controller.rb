# frozen_string_literal: true

# EducationsController manages CRUD actions for education records.
# Inherits officer-level access control from OfficerApplicationController.
class EducationsController < OfficerApplicationController
  # Sets the education object for actions that require a specific record.
  before_action :set_education, only: %i[show edit update destroy]

  # GET /educations or /educations.json
  # Fetches all education records and assigns them to @educations.
  #
  # @return [void]
  def index
    @educations = Education.all
  end

  # GET /educations/1 or /educations/1.json
  # Displays a specific education record.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
  def show
    respond_to do |format|
      format.html # Renders the default HTML view.
      format.json { render :show, status: :ok, location: @education }
    end
  end

  # GET /educations/new
  # Initializes a new education object for creation.
  #
  # @return [void]
  def new
    @education = Education.new
  end

  # GET /educations/1/edit
  # Provides the form for editing a specific education record.
  #
  # @return [void]
  def edit; end

  # POST /educations or /educations.json
  # Creates a new education record.
  # Validates presence and type of educationName and educationType parameters.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
  def create
    @education = Education.new(education_params)

    if params[:education][:educationName].blank? || !%w[Minor Major minor major].include?(params[:education][:educationType])
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { error: 'Invalid educationName or educationType' }, status: :unprocessable_entity }
        # Adds validation errors if educationName or educationType are invalid
        @education.errors.add(:educationName, :invalid, message: 'Invalid educationName') if params[:education][:educationName].blank?
        @education.errors.add(:educationType, :invalid, message: 'Invalid educationType') unless %w[minor major].include?(params[:education][:educationType])
      end
      return
    end

    respond_to do |format|
      if @education.save
        format.html { redirect_to education_url(@education), notice: 'Education was successfully created.' }
        format.json { render :show, status: :created, location: @education }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /educations/1 or /educations/1.json
  # Updates a specific education record.
  # Validates presence and type of educationName and educationType parameters.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
  def update
    @education = Education.find(params[:id])

    if params[:education][:educationName].blank? || !%w[Minor Major minor major].include?(params[:education][:educationType])
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { error: 'Invalid educationName or educationType' }, status: :unprocessable_entity }
        # Adds validation errors if educationName or educationType are invalid
        @education.errors.add(:educationName, :invalid, message: 'Invalid educationName') if params[:education][:educationName].blank?
        @education.errors.add(:educationType, :invalid, message: 'Invalid educationType') unless %w[minor major].include?(params[:education][:educationType])
      end
      return
    end

    respond_to do |format|
      if @education.update(education_params)
        format.html { redirect_to education_url(@education), notice: 'Education was successfully updated.' }
        format.json { render :show, status: :ok, location: @education }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /educations/1 or /educations/1.json
  # Deletes a specific education record.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
  def destroy
    @education.destroy

    respond_to do |format|
      format.html { redirect_to educations_url, notice: 'Education was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Finds and sets the education object for actions that require a specific record.
  #
  # @return [void]
  def set_education
    @education = Education.find(params[:id])
  end

  # Defines and permits the allowed parameters for education objects.
  #
  # @return [ActionController::Parameters] Filtered parameters for creating or updating an education record.
  def education_params
    params.require(:education).permit(:educationName, :educationType, :educationDescription)
  end
end
