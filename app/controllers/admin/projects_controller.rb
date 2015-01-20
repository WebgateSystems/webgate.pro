class Admin::ProjectsController < Admin::HomeController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.order(:id)
  end

  def show
  end

  def new
    @project = Project.new
    @project.technologies.build 
    @project.screenshots.build
  end

  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        format.html { redirect_to [:admin, @project], notice: 'Successfully created admin/project.' }
        format.json {    
          params[:screenshots]['file'].each do |s|
            logger.debug "!!!Screenshots params: #{s[1]}"
            #@project.screenshots.create!(file: s[1])
          end
          render json: @project, status: :created, location: [:admin, @project]
        }
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
        format.json {    
          params[:screenshots]['file'].each do |s|
            logger.debug "!!!Screenshots params: #{s[1]}"
            #@project.screenshots.create!(file: s[1][:filename])
          end
          render json: {message: 'success' }, status: :ok
        }
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

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:shortlink, :title, :description, :keywords, :content, :livelink, :publish,
                                    technologies_attributes: [:id, :title, :technology_group_id, :_destroy],
                                    screenshots_attributes: [:id, :file, :project_id, :position, :_destroy])
  end

end
