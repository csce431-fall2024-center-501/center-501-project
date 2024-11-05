# frozen_string_literal: true

# ProjectsController manages CRUD actions for project records and provides a preview
# feature for rendering Markdown content.
class ProjectsController < ApplicationController
  # Sets the project object for actions that require a specific record.
  before_action :set_project, only: %i[show edit update destroy preview]
  
  # Disables CSRF protection for JSON requests, allowing null sessions.
  protect_from_forgery with: :null_session

  # GET /projects or /projects.json
  # Lists all projects and assigns them to @projects.
  #
  # @return [void]
  def index
    @projects = Project.all
  end

  # GET /projects/1 or /projects/1.json
  # Displays a specific project and its associated photos.
  # Converts project Markdown content to HTML.
  #
  # @return [void]
  def show
    @photos = @project.photos
    @html_output = markdown_to_html(@project.markdownBody.to_s)
  end

  # GET /projects/new
  # Initializes a new project object for creation or renders Markdown preview.
  # Requires officer-level permissions.
  #
  # @return [void]
  def new
    return unless require_officer

    if request.post?
      data = params[:data]
      preview_html = markdown_to_html(data)
      render json: { message: 'Success', result: preview_html }
    else
      @project = Project.new
    end
  end

  # GET /projects/1/edit
  # Provides the form for editing a specific project.
  # Requires officer-level permissions.
  #
  # @return [void]
  def edit
    return unless require_officer
  end

  # POST /projects or /projects.json
  # Saves a new project record to the database.
  # Requires officer-level permissions.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
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
  # Updates an existing project record in the database.
  # Requires officer-level permissions.
  #
  # Responds to HTML or JSON format.
  #
  # @return [void]
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

  # DELETE /projects/1
  # Marks a project for deletion.
  # Requires officer-level permissions.
  #
  # @return [void]
  def delete
    return unless require_officer
    @project = Project.find(params[:id])
  end

  # DELETE /projects/1 or /projects/1.json
  # Permanently deletes a project record from the database.
  # Requires officer-level permissions.
  #
  # Responds to HTML format.
  #
  # @return [void]
  def destroy
    return unless require_officer

    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully deleted.'
  end

  # GET /projects/1/preview
  # Renders a Markdown preview for a project.
  #
  # @return [JSON] JSON response containing rendered HTML from Markdown
  def preview
    data = params[:data]
    preview_html = markdown_to_html(data)
    render json: { message: 'Success', result: preview_html }
  end

  private

  # Finds and sets the project object based on the id parameter.
  #
  # @return [void]
  def set_project
    @project = Project.find(params[:id])
  end

  # Defines and permits the allowed parameters for creating/updating a project.
  #
  # @return [ActionController::Parameters] Filtered parameters for project creation/update
  def project_params
    params.require(:project).permit(:projectName, :projectDesc, :locationID, :projectStartDate, :isProjectActive, :markdownBody)
  end

  # Converts Markdown text to HTML for preview purposes.
  #
  # @param text [String] The Markdown text to be converted
  # @return [String] Rendered HTML
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
