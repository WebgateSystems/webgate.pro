class Admin::MembersController < Admin::HomeController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  def index
    @members = Member.rank(:position).all
  end

  def show
    @member_links = @member.member_links.rank(:position)
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

  def update_position
    @member = Member.find(member_params[:member_id])
    @member.position_position = member_params[:row_position]
    respond_to do |format|
      if @member.save!
        format.json { head :ok }
      else
        format.json { head :error }
      end
    end
  end

  def sort_member_links
    @member_link = MemberLink.find(member_params[:member_link_id])
    @member_link.position_position = member_params[:row_position]
    respond_to do |format|
      if @member_link.save!
        format.json { head :ok }
      else
        format.json { head :error }
      end
    end
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:member_id, :row_position, :name, :job_title, :education, :description,
                                    :member_link_id, :avatar, :avatar_cache, :motto, technology_ids: [],
                                    technologies_attributes: [:id, :title, :technology_group_id, :_destroy],
                                    member_links_attributes: [:id, :name, :link, :member_id, :position, :_destroy])
  end

end
