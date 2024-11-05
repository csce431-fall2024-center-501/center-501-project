# frozen_string_literal: true

# SponsorshipsController manages CRUD actions for sponsorship records.
# Includes access control for officer-level users.
class SponsorshipsController < ApplicationController
  # Sets the sponsorship object for actions that require a specific record.
  before_action :set_sponsorship, only: %i[show edit update destroy]

  # GET /sponsorships
  # Lists all sponsorships, ordered by donation amount.
  #
  # @return [void]
  def index
    @sponsorships = Sponsorship.order(:sponsor_donation)
  end

  # GET /sponsorships/1
  # Displays a specific sponsorship record.
  #
  # @return [void]
  def show; end

  # GET /sponsorships/new
  # Initializes a new sponsorship object for creation.
  # Requires officer-level permissions.
  #
  # @return [void]
  def new
    return unless require_officer
    @sponsorship = Sponsorship.new
  end

  # GET /sponsorships/1/edit
  # Provides the form for editing a specific sponsorship record.
  # Requires officer-level permissions.
  #
  # @return [void]
  def edit
    return unless require_officer
  end

  # DELETE /sponsorships/1/delete
  # Marks a sponsorship for deletion.
  # Requires officer-level permissions.
  #
  # @return [void]
  def delete
    return unless require_officer
    @sponsorship = Sponsorship.find(params[:id])
  end

  # POST /sponsorships
  # Saves a new sponsorship record to the database.
  # Requires officer-level permissions.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
  def create
    return unless require_officer
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

  # PATCH/PUT /sponsorships/1
  # Updates an existing sponsorship record in the database.
  # Requires officer-level permissions.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
  def update
    return unless require_officer
    respond_to do |format|
      if @sponsorship.update(sponsorship_params)
        format.html { redirect_to sponsorships_path, notice: 'Sponsorship record was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sponsorship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sponsorships/1
  # Permanently deletes a sponsorship record from the database.
  # Requires officer-level permissions.
  #
  # @return [void]
  def destroy
    return unless require_officer
    @sponsorship.destroy
    redirect_to sponsorships_path
  end

  private

  # Finds and sets the sponsorship object based on the id parameter.
  #
  # @return [void]
  def set_sponsorship
    @sponsorship = Sponsorship.find(params[:id])
  end

  # Defines and permits the allowed parameters for creating/updating a sponsorship.
  #
  # @return [ActionController::Parameters] Filtered parameters for sponsorship creation/update
  def sponsorship_params
    params.require(:sponsorship).permit(:sponsor_name, :sponsor_lead_name, :sponsor_phone, :sponsor_email,
                                        :sponsor_donation, :sponsor_end_of_contract, :sponsor_logo)
  end
end
