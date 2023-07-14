module Admin
  class TechnologiesController < Admin::HomeController
    before_action :set_technology, only: %i[show edit update destroy]
    before_action :set_technology_groups, only: %i[new create edit update]

    def index
      @technologies = Technology.order(:id).includes(:technology_group, technology_group: :translations)
    end

    def show; end

    def new
      @technology = Technology.new
      @technology.technology_group_id = params[:technology_group_id]
    end

    def create
      @technology = Technology.new(technology_params)
      if @technology.save
        redirect_to [:admin, @technology], notice: "#{t(:technology)} #{t(:was_successfully_created)}."
      else
        render 'new'
      end
    end

    def edit; end

    def update
      if @technology.update(technology_params)
        redirect_to [:admin, @technology], notice: "#{t(:technology)} #{t(:was_successfully_updated)}."
      else
        render 'edit'
      end
    end

    def destroy
      @technology.destroy
      redirect_to :back, notice: "#{t(:technology)} #{t(:was_successfully_destroyed)}."
    end

    private

    def set_technology
      @technology = Technology.find(params[:id])
    end

    def set_technology_groups
      @technology_groups = TechnologyGroup.includes(:translations)
    end

    def technology_params
      params.require(:technology).permit(:title, :link, :description, :technology_group_id, :logo, :logo_cache)
    end
  end
end
