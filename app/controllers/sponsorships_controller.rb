# frozen_string_literal: true

class SponsorshipsController < ApplicationController
  before_action :set_sponsorship, only: %i[show edit update destroy]

  def index
    @sponsorships = Sponsorship.order(:sponsor_donation)
  end

  def show; end

  def new
    @sponsorship = Sponsorship.new
  end

  def edit; end

  def delete
    @sponsorship = Sponsorship.find(params[:id])
  end

  def create
    @sponsorship = Sponsorship.new(sponsorship_params)

    respond_to do |format|
      if @sponsorship.save
        format.html { redirect_to sponsorships_path, notice: 'Sponsorship record was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sponsorship.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sponsorship.update(sponsorship_params)
        format.html { redirect_to sponsorships_path, notice: 'Sponsorship record was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sponsorship.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sponsorship.destroy
    redirect_to sponsorships_path
  end

  private

  def set_sponsorship
    @sponsorship = Sponsorship.find(params[:id])
  end

  def sponsorship_params
    params.require(:sponsorship).permit(:sponsor_name, :sponsor_lead_name, :sponsor_phone, :sponsor_email,
                                        :sponsor_donation, :sponsor_end_of_contract, :sponsor_logo)
  end
end
