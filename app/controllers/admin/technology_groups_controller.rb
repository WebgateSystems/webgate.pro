module Admin
  class TechnologyGroupsController < Admin::HomeController
    before_action :set_technology_group, only: %i[show edit update destroy]

    def index
      @technology_groups = TechnologyGroup.rank(:position).includes(:translations)
    end

    def show
      @technologies = @technology_group.technologies.rank(:position)
    end

    def new
      @technology_group = TechnologyGroup.new
    end

    def create
      @technology_group = TechnologyGroup.new(technology_group_params)
      if @technology_group.save
        ::TranslationWorker.perform_async(@technology_group.class.name, @technology_group.id, cookies[:lang])
        redirect_to [:admin, @technology_group], notice: "#{t(:technology_group)} #{t(:was_successfully_created)}."
      else
        render 'new'
      end
    end

    def edit; end

    def update
      return add_translate(@technology_group, admin_technology_group_path(@technology_group)) if params[:translation]

      if @technology_group.update(technology_group_params)
        redirect_to [:admin, @technology_group], notice: "#{t(:technology_group)} #{t(:was_successfully_updated)}."
      else
        render 'edit'
      end
    end

    def destroy
      @technology_group.destroy
      redirect_to admin_technology_groups_url, notice: "#{t(:technology_group)} #{t(:was_successfully_destroyed)}."
    end

    def update_position
      @technology_group = TechnologyGroup.find(technology_group_params[:technology_group_id])
      @technology_group.position_position = technology_group_params[:row_position]
      respond_to do |format|
        @technology_group.save! ? format.json { head :ok } : format.json { head :error }
        format.html
      end
    end

    def sort_technologies
      @technology = Technology.find(technology_group_params[:technology_id])
      @technology.position_position = technology_group_params[:row_position]
      respond_to do |format|
        @technology.save! ? format.json { head :ok } : format.json { head :error }
        format.html
      end
    end

    private

    def set_technology_group
      @technology_group = TechnologyGroup.find(params[:id])
    end

    def technology_group_params
      params.require(:technology_group).permit(
        :technology_group_id, :row_position, :technology_id, :title, :description, :color
      )
    end
  end
end
