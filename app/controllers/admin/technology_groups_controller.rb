class Admin::TechnologyGroupsController < Admin::HomeController
  before_action :set_technology_group, only: [:show, :edit, :update, :destroy]

  def index
    @technology_groups = TechnologyGroup.rank(:position).all
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

  def update_position
    @technology_group = TechnologyGroup.find(technology_group_params[:technology_group_id])
    @technology_group.position_position = technology_group_params[:row_position]
    respond_to do |format|
      if @technology_group.save!
        format.json { head :ok }
      else
        format.json { head :error }
      end
    end
  end

  def sort_technologies
    @technology = Technology.find(technology_group_params[:technology_id])
    @technology.position_position = technology_group_params[:row_position]
    respond_to do |format|
      if @technology.save!
        format.json { head :ok }
      else
        format.json { head :error }
      end
    end
  end

  private

  def set_technology_group
    @technology_group = TechnologyGroup.find(params[:id])
  end

  def technology_group_params
    params.require(:technology_group).permit(:technology_group_id, :row_position, :technology_id, :title, :description)
  end

end
