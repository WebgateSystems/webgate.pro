class Admin::TechnologyGroupsController < Admin::HomeController
  before_action :set_technology_group, only: [:show, :edit, :update, :destroy]

  def index
    @technology_groups = TechnologyGroup.order(:id)
  end

  def show
  end

  def new
    @technology_group = TechnologyGroup.new
  end

  def create
    @technology_group = TechnologyGroup.new(technology_group_params)
    if @technology_group.save
      redirect_to [:admin, @technology_group], notice: 'Successfully created admin/technology_group.'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @technology_group.update_attributes(technology_group_params)
      redirect_to [:admin, @technology_group], notice: 'Successfully updated admin/technology_group.'
    else
      render 'edit'
    end
  end

  def destroy
    @technology_group.destroy
    redirect_to admin_technology_groups_url, notice: 'Successfully destroyed admin/technology_group.'
  end

  private

  def set_technology_group
    @technology_group = TechnologyGroup.find(params[:id])
  end

  def technology_group_params
    params.require(:technology_group).permit(:title, :description)
  end

end
