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
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to [:admin, @project], notice: 'Successfully created admin/project.'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to [:admin, @project], notice: 'Successfully updated admin/project.'
    else
      render 'edit'
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
    params.require(:project).permit(:shortlink, :title, :description, :keywords, :content,
                                    :screenshot1, :screenshot2, :screenshot3,
                                    technologies_attributes: [:id, :title, :description, :_destroy])
  end

end
