class Admin::MembersController < Admin::HomeController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :sort]

  def index
    @members = Member.order(:id)
  end

  def show
  end

  def new
    @member = Member.new
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
    redirect_to admin_members_url, notice: 'Successfully destroyed admin/member.'
  end

  def sort
    params[:order].each do |key, value|
      @member.member_links.find(value[:id]).update_attribute(:position, value[:position])
    end
    render nothing: true
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:name, :shortdesc, :description, :avatar, :motto, technology_ids: [],
                                    technologies_attributes: [:id, :title, :technology_group_id, :_destroy],
                                    member_links_attributes: [:id, :logo, :logo_cache,
                                    :name, :link, :member_id, :position, :_destroy])
  end

end
