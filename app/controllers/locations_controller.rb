class LocationsController < OfficerApplicationController
    # ensure location is set b4 performing any actions on it
    before_action :set_location, only: %i[show edit update destroy delete]

    # list all locations
    def index
        @locations = Location.all
    end

    def show
    end

    # make an empty location object
    def new
        @location = Location.new
    end

    def edit
    end

    # save new location record to database
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

    # update existing location record in database
    def update
        respond_to do |format|
            if @location.update(location_params)
                flash[:notice] = "Photo was successfully edited."
                format.html { redirect_to @location, notice: 'Location was successfully updated.' }
                format.json { render :show, status: :ok, location: @location }
            else
                format.html { render :edit }
                format.json { render json: @location.errors, status: :unprocessable_entity }
            end
        end
    end

    # delete location record from database
    def destroy
        @location.destroy
        respond_to do |format|
            flash[:notice] = "Photo was successfully deleted."
            format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def delete
        flash[:notice] = "Photo was successfully deleted."
        @location = Location.find(params[:id])
    end

    # find location based on id parameter
    def set_location
        @location = Location.find(params[:id])
    end

    # filter parameters for creating/updating a Location
    def location_params
        params.require(:location).permit(:address, :city, :state, :zip_code, :country)
    end

end