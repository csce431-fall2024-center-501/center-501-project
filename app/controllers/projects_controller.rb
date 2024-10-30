# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy preview]
  protect_from_forgery with: :null_session

  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1 or /projects/1.json
  def show
    @project = Project.find(params[:id])
    @photos = Photo.where(photoPageLocation: 'Projects')
    @html_output = markdown_to_html(@project.markdownBody.to_s)
  end

  # GET /projects/new
  def new
    return unless require_officer
    # Handles POST requests
    if request.post?
      data = params[:data]
      preview_html = markdown_to_html(data)
      render json: { message: 'Success', result: preview_html }
    # handles other (GET) requests
    else
      @project = Project.new
    end
  end

  # GET /projects/1/edit
  def edit
    return unless require_officer
    @project = Project.find(params[:id])
  end

  # POST /projects or /projects.json
  def create
    return unless require_officer
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    return unless require_officer
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def delete
    return unless require_officer
    @project = Project.find(params[:id])
  end

  def destroy
    return unless require_officer
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully deleted.'

    # respond_to do |format|
    #  format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
    #  format.json { head :no_content }
    # end
  end

  def preview
    @project = Project.find(params[:id])
    data = params[:data]
    preview_html = markdown_to_html(data)
    render json: { message: 'Success', result: preview_html }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:projectName, :projectDesc, :locationID, :projectStartDate, :isProjectActive,
                                    :markdownBody)
  end

  def markdown_to_html(text)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, {
                                         strikethrough: true,
                                         fenced_code_blocks: true,
                                         autolink: true,
                                         tables: true,
                                         superscript: true,
                                         underline: true,
                                         highlight: true,
                                         footnotes: true,
                                         no_intra_emphasis: true,
                                         space_after_headers: true,
                                         lax_spacing: true,
                                         disable_indented_code_blocks: true
                                       })
    markdown.render(text).html_safe
  end
end
