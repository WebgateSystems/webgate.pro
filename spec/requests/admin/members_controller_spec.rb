RSpec.describe Admin::MembersController, type: :request do
  before do
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
    allow_any_instance_of(ApplicationController).to receive(:geoip_lang).and_return('en')
  end

  describe '#update' do
    let!(:member) { create(:member) }

    context 'when params valid' do
      let(:params) { attributes_for(:member) }

      it 'is update member name' do
        expect do
          put "/admin/members/#{member.id}", params: { member: params }
        end.to(change { Member.first.name })
      end

      it 'is update member job_title' do
        expect do
          put "/admin/members/#{member.id}", params: { member: params }
        end.to(change { Member.first.job_title })
      end

      it 'is update member education' do
        expect do
          put "/admin/members/#{member.id}", params: { member: params }
        end.to(change { Member.first.education })
      end

      it 'is update member description' do
        expect do
          put "/admin/members/#{member.id}", params: { member: params }
        end.to(change { Member.first.description })
      end

      it 'is update member motto' do
        expect do
          put "/admin/members/#{member.id}", params: { member: params }
        end.to(change { Member.first.motto })
      end
    end

    context 'when invalid params' do
      it 'is not update member name' do
        expect do
          put "/admin/members/#{member.id}", params: { member: { name: nil } }
        end.not_to(change { Member.first.name })
      end
    end
  end

  describe '#update position' do
    let!(:member) { create(:member, position: 1) }
    let!(:second_member) { create(:member, position: 0) }

    context 'when admin update member position' do
      let(:params) { { member_id: member.id, row_position: second_member.position } }

      it 'is update member position' do
        expect do
          put '/admin/members/update_position', params: { member: params }
        end.to(change { Member.first.position })
      end
    end
  end

  describe '#sort member links' do
    let!(:member_link) { create(:member_link, position: 1) }

    context 'when admin run sort member member_links function' do
      let(:params) { { member_link_id: member_link.id, row_position: 0 } }

      it 'is sort member member_links' do
        expect do
          put "/admin/members/#{member_link.member.id}/sort_member_links", params: { member: params }
        end.to(change { MemberLink.first.position })
      end
    end
  end

  # describe '#sort member technologies' do
  describe '#sort member technologies' do
    it 'sorts member technologies' do
      member = create(:member)
      technology = I18n.with_locale(:en) { create(:technology, position: 0) }
      second_technology = I18n.with_locale(:en) { create(:technology, position: 1) }
      technologies_member = TechnologiesMember.create!(member:, technology:, position: 0)
      second_technologies_member = TechnologiesMember.create!(member:, technology: second_technology, position: 1)

      params = {
        member_technology_id: technologies_member.technology.id,
        row_tech_position: second_technologies_member.position
      }

      expect do
        put "/admin/members/#{member.id}/sort_member_technologies",
            params: { member: params }, as: :json
      end.to(change { technologies_member.reload.position }.from(0))

      expect(technologies_member.reload.position).not_to eq(0)
    end
  end
end
