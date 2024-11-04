class PhotosController < OfficerApplicationController
  before_action :set_photo, only: %i[show edit update destroy]
  before_action :set_projects, only: [:new, :edit]
    
  def index
    @photos = Photo.all
  end

  def show
  end

  def new
    @photo = Photo.new
  end

  def edit
  end

  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render :show, status: :created, location: @photo }
      else
        @projects = Project.all
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        @projects = Project.all
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete
    @photo = Photo.find(params[:id])
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_photo
    @photo = Photo.find(params[:id])
  end

  def set_projects
    @projects = Project.all
  end

  # Only allow a list of trusted parameters through.
  def photo_params
    params.require(:photo).permit(:description, :displayed_in_home_gallery, :url, :project_id)
  end
end