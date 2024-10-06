class PhotosController < ApplicationController
before_action :set_photo, only: %i[show edit update destroy]

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

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_photo
        @photo = Photo.find(params[:photoLink])
    end

    # Only allow a list of trusted parameters through.
    def photo_params
        params.require(:photo).permit(:photoLink, :photoDescription, :photoType, :photoPageLocation)
    end
end
