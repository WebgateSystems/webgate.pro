class Admin::TechnologiesController < Admin::HomeController
  before_action :set_technology, only: [:show, :edit, :update, :destroy]
  # before_action :set_technology_groups, only: [:new, :edit, :update]


  def index
    @technologies = Technology.order(:id)
  end

  def show
  end

  def new
    @technology = Technology.new
    @technology.technology_group_id = params[:technology_group_id]
  end

  def create
    @technology = Technology.new(technology_params)
    if @technology.save
      redirect_to [:admin, @technology], notice: 'Successfully created admin/technology.'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @technology.update_attributes(technology_params)
      redirect_to [:admin, @technology], notice: 'Successfully updated admin/technology.'
    else
      render 'edit'
    end
  end

  def destroy
    @technology.destroy
    redirect_to :back, notice: 'Successfully destroyed admin/technology.'
  end

  private

  def set_technology
    @technology = Technology.find(params[:id])
  end

  def set_technology_groups
    @technology_groups = TechnologyGroup.all.inject([]){|res, k| res << [k.title,k.id]}
  end

  def technology_params
    params.require(:technology).permit(:title, :link, :description, :technology_group_id, :logo, :logo_cache)
  end

end
