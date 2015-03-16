class Admin::ProjectsController < Admin::HomeController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.rank(:position).all
  end

  def show
    @screenshots = @project.screenshots.rank(:position)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        format.html { redirect_to [:admin, @project], notice: 'Successfully created admin/project.' }
        format.json { render json: @project, status: :created, location: [:admin, @project] }
      else
        format.html { render 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to [:admin, @project], notice: 'Successfully updated admin/project.' }
        format.json { render json: { message: 'success' }, status: :ok }
      else
        format.html { render 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to admin_projects_url, notice: 'Successfully destroyed admin/project.' }
      format.json { head :no_content }
    end
  end

  def update_position
    @project = Project.find(project_params[:project_id])
    @project.position_position = project_params[:row_position]
    respond_to do |format|
      if @project.save!
        format.json { head :ok }
      else
        format.json { head :error }
      end
    end
  end

  def sort_screenshots
    @screenshot = Screenshot.find(project_params[:screenshot_id])
    @screenshot.position_position = project_params[:row_position]
    respond_to do |format|
      if @screenshot.save!
        format.json { head :ok }
      else
        format.json { head :error }
      end
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:project_id, :screenshot_id, :row_position, :shortlink, :title, :description,
                                    :keywords, :content, :livelink, :publish, technology_ids: [],
                                    technologies_attributes: [:id, :title, :technology_group_id],
                                    screenshots_attributes: [:id, :file, :file_cache, :project_id, :position, :_destroy])
  end

end
