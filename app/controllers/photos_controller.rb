# PhotosController manages CRUD actions for photo records.
# Inherits officer-level access control from OfficerApplicationController.
class PhotosController < OfficerApplicationController
  # Sets the photo object for actions that require a specific record.
  before_action :set_photo, only: %i[show edit update destroy]

  # Loads all projects to be available in new and edit views.
  before_action :set_projects, only: %i[new edit]
    
  # GET /photos
  # Lists all photos and assigns them to @photos.
  #
  # @return [void]
  def index
    @photos = Photo.all
  end

  # GET /photos/1
  # Displays a specific photo record.
  #
  # @return [void]
  def show; end

  # GET /photos/new
  # Initializes a new photo object for creation.
  #
  # @return [void]
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  # Provides the form for editing a specific photo record.
  #
  # @return [void]
  def edit; end

  # POST /photos
  # Saves a new photo record to the database.
  # If unsuccessful, reloads all projects for the form and renders new view.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
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

  # PATCH/PUT /photos/1
  # Updates an existing photo record in the database.
  # If unsuccessful, reloads all projects for the form and renders edit view.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
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

  # DELETE /photos/1
  # Deletes a photo record from the database.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /photos/1/delete
  # Finds a photo by ID for deletion.
  #
  # @return [void]
  def delete
    @photo = Photo.find(params[:id])
  end

  private

  # Finds and sets the photo object based on the id parameter.
  #
  # @return [void]
  def set_photo
    @photo = Photo.find(params[:id])
  end

  # Loads all projects and assigns them to @projects for selection in the form.
  #
  # @return [void]
  def set_projects
    @projects = Project.all
  end

  # Defines and permits the allowed parameters for creating/updating a photo.
  #
  # @return [ActionController::Parameters] Filtered parameters for photo creation/update.
  def photo_params
    params.require(:photo).permit(:description, :displayed_in_home_gallery, :url, :project_id)
  end
end
