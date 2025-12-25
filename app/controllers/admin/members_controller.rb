module Admin
  class MembersController < Admin::HomeController
    before_action :set_member, only: %i[show update destroy sort_member_technologies]
    before_action :set_technologies, only: %i[new edit create update]

    def index
      @members = Member.rank(:position).includes(:translations)
    end

    def show
      @member_links = @member.member_links.rank(:position).includes(:translations)
      @technologies = @member.technologies.rank(:position)
    end

    def new
      @member = Member.new
    end

    def create
      @member = Member.new(member_params)
      if @member.save
        ::TranslationWorker.perform_async(@member.class.name, @member.id, cookies[:lang]) unless GptSettings.enabled?
        redirect_to [:admin, @member], notice: "#{t(:member)} #{t(:was_successfully_created)}."
      else
        render 'new'
      end
    end

    def edit
      @member = Member.includes(:member_links, member_links: :translations).find(params[:id])
    end

    def update
      return add_translate(@member, admin_member_path(@member)) if params[:translation]

      if @member.update(member_params)
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
        @member.save! ? format.json { head :ok } : format.json { head :error }
        format.html
      end
    end

    def sort_member_links
      @member_link = MemberLink.find(member_params[:member_link_id])
      @member_link.update_column(:position, member_params[:row_position])
      respond_to do |format|
        format.json { head :ok }
        format.html
      end
    end

    def sort_member_technologies
      @technologies_member = TechnologiesMember.find_by(member_id: @member.id,
                                                        technology_id: member_params[:member_technology_id])
      @technologies_member.position_position = member_params[:row_tech_position]
      respond_to do |format|
        if @technologies_member.save!
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
      params.require(:member).permit(
        :member_id, :row_position, :row_tech_position, :name, :job_title, :education, :description,
        :member_link_id, :member_technology_id, :avatar, :avatar_cache, :motto, :publish,
        technology_ids: [],
        technologies_attributes: %i[id title technology_group_id _destroy],
        member_links_attributes: %i[id name link member_id position _destroy]
      )
    end
  end
end
