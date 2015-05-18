class Admin::MembersController < Admin::HomeController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :set_technologies, only: [:new, :edit, :create, :update]

  def index
    @members = Member.rank(:position).includes(:translations)
  end

  def show
    @member_links = @member.member_links.rank(:position)
    @technologies = @member.technologies.rank(:member_position)
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to [:admin, @member], notice: "#{t(:member)} #{t(:was_successfully_created)}."
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @member.update_attributes(member_params)
      redirect_to [:admin, @member], notice: "#{t(:member)} #{t(:was_successfully_updated)}."
    else
      render 'edit'
    end
  end

  def destroy
    @member.destroy
    redirect_to admin_members_url, notice: "#{t(:member)} #{t(:was_successfully_destroyed)}."
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

  def sort_member_technologies
    @technology = Technology.find(member_params[:member_technology_id])
    @technology.member_position_position = member_params[:row_tech_position]
    respond_to do |format|
      if @technology.save!
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

  def set_technologies
    @technologies = Technology.includes(:technology_group)
  end

  def member_params
    params.require(:member).permit(:member_id, :row_position, :row_tech_position, :name, :job_title, :education, :description,
                                    :member_link_id, :member_technology_id, :avatar, :avatar_cache, :motto, :publish, technology_ids: [],
                                    technologies_attributes: [:id, :title, :technology_group_id, :_destroy],
                                    member_links_attributes: [:id, :name, :link, :member_id, :position, :_destroy])
  end

end
