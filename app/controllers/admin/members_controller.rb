class Admin::MembersController < Admin::HomeController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  def index
    @member = Member.order(:id)
  end

  def show
  end

  def new
    @member = Member.new
    @member.technologies.build
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to [:admin, @member], notice: 'Successfully created admin/member.'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @member.update_attributes(member_params)
      redirect_to [:admin, @member], notice: 'Successfully updated admin/member.'
    else
      render 'edit'
    end
  end

  def destroy
    @member.destroy
    redirect_to admin_member_url, notice: 'Successfully destroyed admin/member.'
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:name, :shortdesc, :description, :avatar,
                                    technologies_attributes: [:id, :title, :technology_group_id, :_destroy])
  end

end
