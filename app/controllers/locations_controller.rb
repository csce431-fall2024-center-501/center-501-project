# LocationsController manages CRUD actions for location records.
# Inherits officer-level access control from OfficerApplicationController.
class LocationsController < OfficerApplicationController
    # Sets the location object for actions that require a specific record.
    before_action :set_location, only: %i[show edit update destroy delete]
  
    # GET /locations
    # Lists all locations and assigns them to @locations.
    #
    # @return [void]
    def index
      @locations = Location.all
    end
  
    # GET /locations/1
    # Displays a specific location record.
    #
    # @return [void]
    def show; end
  
    # GET /locations/new
    # Initializes a new location object for creation.
    #
    # @return [void]
    def new
      @location = Location.new
    end
  
    # GET /locations/1/edit
    # Provides the form for editing a specific location record.
    #
    # @return [void]
    def edit; end
  
    # POST /locations
    # Saves a new location record to the database.
    #
    # Responds to HTML or JSON format.
    #
    # @return [void]
    def create
      @location = Location.new(location_params)
  
      respond_to do |format|
        if @location.save
          flash[:notice] = "Location was successfully created."
          format.html { redirect_to @location, notice: 'Location was successfully created.' }
          format.json { render :show, status: :created, locations: @location }
        else
          format.html { render :new }
          format.json { render json: @location.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /locations/1
    # Updates an existing location record in the database.
    #
    # Responds to HTML or JSON format.
    #
    # @return [void]
    def update
      respond_to do |format|
        if @location.update(location_params)
          flash[:notice] = "Location was successfully updated."
          format.html { redirect_to @location, notice: 'Location was successfully updated.' }
          format.json { render :show, status: :ok, location: @location }
        else
          format.html { render :edit }
          format.json { render json: @location.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /locations/1
    # Deletes a location record from the database.
    #
    # Responds to HTML or JSON format.
    #
    # @return [void]
    def destroy
      @location.destroy
      respond_to do |format|
        flash[:notice] = "Location was successfully deleted."
        format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  
    # DELETE /locations/1/delete
    # Finds a location by ID for deletion.
    #
    # @return [void]
    def delete
      flash[:notice] = "Location was successfully deleted."
      @location = Location.find(params[:id])
    end
  
    private
  
    # Finds and sets the location object based on the id parameter.
    #
    # @return [void]
    def set_location
      @location = Location.find(params[:id])
    end
  
    # Defines and permits the allowed parameters for creating/updating a location.
    #
    # @return [ActionController::Parameters] Filtered parameters for location creation/update.
    def location_params
      params.require(:location).permit(:address, :city, :state, :zip_code, :country)
    end
  end
  