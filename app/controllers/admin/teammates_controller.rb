class Admin::TeammatesController < Admin::HomeController
  before_action :set_teammate, only: [:show, :edit, :update, :destroy]

  def index
    @teammate = Teammate.order(:id)
  end

  def show
  end

  def new
    @teammate = Teammate.new
    @teammate.technologies.build
  end

  def create
    @teammate = Teammate.new(teammate_params)
    if @teammate.save
      redirect_to [:admin, @teammate], notice: 'Successfully created admin/teammate.'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @teammate.update_attributes(teammate_params)
      redirect_to [:admin, @teammate], notice: 'Successfully updated admin/teammate.'
    else
      render 'edit'
    end
  end

  def destroy
    @teammate.destroy
    redirect_to admin_teammates_url, notice: 'Successfully destroyed admin/teammate.'
  end

  private

  def set_teammate
    @teammate = Teammate.find(params[:id])
  end

  def teammate_params
    params.require(:teammate).permit(:name, :shortdesc, :description, :avatar,
                                    technologies_attributes: [:id, :title, :technology_group_id, :_destroy])
  end

end
