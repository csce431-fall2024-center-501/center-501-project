class SponsorshipsController < ApplicationController
  def index
    @sponsorships = Sponsorship.order(:sponsorDonation)
  end

  def show
    @sponsorship = Sponsorship.find(params[:id])
  end

  def new
    @sponsorship = Sponsorship.new
  end

  def edit
    @sponsorship = Sponsorship.find(params[:id])
  end

  def delete
    @sponsorship = Sponsorship.find(params[:id])
  end

  def create
    @sponsorship = Sponsorship.new(sponsorship_params)

    respond_to do |format|
      if @sponsorship.save
        format.html { redirect_to sponsorships_path, notice: "Sponsorship record was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sponsorship.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @sponsorship = Sponsorship.find(params[:id])

    respond_to do |format|
      if @sponsorship.update(sponsorship_params)
        format.html { redirect_to sponsorships_path, notice: "Sponsorship record was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sponsorship.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sponsorship = Sponsorship.find(params[:id])
    @sponsorship.destroy
    redirect_to sponsorships_path
  end

  private

  def sponsorship_params
    params.require(:sponsorship).permit(:sponsorName, :sponsorLeadName, :sponsorPhone, :sponsorEmail, :sponsorDonation, :sponsorEndOfContract)
  end
end
