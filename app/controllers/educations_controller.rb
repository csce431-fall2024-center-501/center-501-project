class EducationsController < AuthenticatedApplicationController
  # Set the education object for specific actions
  before_action :set_education, only: %i[show edit update destroy]

  # GET /educations or /educations.json
  # Fetch all education records and assign them to @educations
  def index
    @educations = Education.all
  end

  # GET /educations/1 or /educations/1.json
  # Show a specific education record
  def show
    respond_to do |format|
      format.html # Render the default HTML view
      format.json { render :show, status: :ok, location: @education } # Render JSON response
    end
  end

  # GET /educations/new
  # Initialize a new education object
  def new
    @education = Education.new
  end

  # GET /educations/1/edit
  # Edit a specific education record
  def edit
  end

  # POST /educations or /educations.json
  # Create a new education record
  def create
    @education = Education.new(education_params)
    if params[:education][:educationName].blank? || !%w[Minor Major minor
                                                        major].include?(params[:education][:educationType])
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { error: 'Invalid educationName or educationType' }, status: :unprocessable_entity }
        if params[:education][:educationName].blank?
          @education.errors.add(:educationName, :invalid,
                                message: 'Invalid educationName')
        end
        unless %w[minor major].include?(params[:education][:educationType])
          @education.errors.add(:educationType, :invalid,
                                message: 'Invalid educationType')
        end
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
  # Update a specific education record
  def update
    @education = Education.find(params[:id])

    if params[:education][:educationName].blank? || !%w[minor major Major
                                                        Minor].include?(params[:education][:educationType])
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { error: 'Invalid educationName or educationType' }, status: :unprocessable_entity }
        if params[:education][:educationName].blank?
          @education.errors.add(:educationName, :invalid,
                                message: 'Invalid educationName')
        end
        unless %w[minor major].include?(params[:education][:educationType])
          @education.errors.add(:educationType, :invalid,
                                message: 'Invalid educationType')
        end
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
  # Delete a specific education record
  def destroy
    @education.destroy

    respond_to do |format|
      format.html { redirect_to educations_url, notice: 'Education was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_education
    @education = Education.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def education_params
    params.require(:education).permit(:educationName, :educationType, :educationDescription)
  end
end
