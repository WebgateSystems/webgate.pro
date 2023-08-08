module Admin
  class ProjectsController < Admin::HomeController
    before_action :set_project, only: %i[show edit update destroy sort_project_technologies]
    before_action :set_technologies, only: %i[new create edit update]

    def index
      @projects = Project.rank(:position).includes(:translations)
    end

    def show
      @screenshots = @project.screenshots.rank(:position)
      @technologies = @project.technologies.rank(:position)
    end

    def new
      @project = Project.new
    end

    def create
      @project = Project.new(project_params)
      respond_to do |format|
        if @project.save
          ::TranslationWorker.perform_async(@project.class, @project.id)
          format.html { redirect_to [:admin, @project], notice: "#{t(:project)} #{t(:was_successfully_created)}." }
          format.json { render json: @project, status: :created, location: [:admin, @project] }
        else
          format.html { render 'new' }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end

    def edit; end

    def update
      return add_translate(@project, admin_project_path(@project)) if params[:translation]

      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to [:admin, @project], notice: "#{t(:project)} #{t(:was_successfully_updated)}." }
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
        format.html { redirect_to admin_projects_url, notice: "#{t(:project)} #{t(:was_successfully_destroyed)}." }
        format.json { head :no_content }
      end
    end

    def update_position
      @project = Project.find(project_params[:project_id])
      @project.position_position = project_params[:row_position]
      respond_to do |format|
        @project.save! ? format.json { head :ok } : format.json { head :error }
        format.html
      end
    end

    def sort_project_screenshots
      @screenshot = Screenshot.find(project_params[:screenshot_id])
      @screenshot.position_position = project_params[:row_position]
      respond_to do |format|
        @screenshot.save! ? format.json { head :ok } : format.json { head :error }
        format.html
      end
    end

    def sort_project_technologies
      @technologies_project = TechnologiesProject.find_by(project_id: @project.id,
                                                          technology_id: project_params[:project_technology_id])
      @technologies_project.position_position = project_params[:row_tech_position]
      respond_to do |format|
        @technologies_project.save! ? format.json { head :ok } : format.json { head :error }
        format.html
      end
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end

    def set_technologies
      @technologies = Technology.includes(:technology_group)
    end

    def project_params
      params.require(:project).permit(:collage, :collage_cache, :project_id, :screenshot_id, :row_position, :shortlink, :title, :description,
                                      :row_tech_position, :project_technology_id, :keywords, :content, :livelink, :publish,
                                      technology_ids: [],
                                      technologies_attributes: %i[id title technology_group_id],
                                      screenshots_attributes: %i[id file file_cache project_id position _destroy])
    end
  end
end
