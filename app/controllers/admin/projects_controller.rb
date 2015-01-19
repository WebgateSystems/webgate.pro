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
          render json: {message: 'success' }, status: 200
        }
      else
        format.html { render 'new' }
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
            #@project.screenshots.create!(file: s[1])
          end
          render json: {message: 'success' }, status: 200
        }
      else
        format.html { render 'edit' }
        format.json { render json: { error: @project.errors.full_messages.join(',') }, status: 400 }
      end
    end
  end

  def destroy
    @project.destroy
    redirect_to admin_projects_url, notice: 'Successfully destroyed admin/project.'
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
