RSpec.describe Admin::TechnologyGroupsController, type: :request do
  before do
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
    allow_any_instance_of(ApplicationController).to receive(:geoip_lang).and_return('en')
    I18n.locale = :en
  end

  describe '#update' do
    let!(:technology_group) { create(:technology_group) }

    context 'when params valid' do
      let(:params) { attributes_for(:technology_group) }

      it 'is update technology_group title' do
        expect do
          put "/admin/technology_groups/#{technology_group.id}", params: { technology_group: params }
        end.to(change { TechnologyGroup.first.title })
      end

      it 'is update technology_group description' do
        expect do
          put "/admin/technology_groups/#{technology_group.id}", params: { technology_group: params }
        end.to(change { TechnologyGroup.first.description })
      end
    end

    context 'when invalid params' do
      it 'is not update technology_group title' do
        expect do
          put "/admin/technology_groups/#{technology_group.id}", params: { technology_group: { title: nil } }
        end.not_to(change { TechnologyGroup.first.title })
      end
    end
  end

  describe '#update position' do
    let!(:technology_group) { I18n.with_locale(:en) { create(:technology_group, position: 1) } }
    let!(:second_technology_group) { I18n.with_locale(:en) { create(:technology_group, position: 0) } }

    context 'when admin update technology_group position' do
      let(:params) { { technology_group_id: technology_group.id, row_position: second_technology_group.position } }

      it 'is update technology_group position' do
        expect do
          put '/admin/technology_groups/update_position', params: { technology_group: params }, as: :json
        end.to(change { TechnologyGroup.first.position })
      end
    end
  end

  describe '#sort technologies' do
    let!(:technology_group) { create(:technology_group) }
    let!(:technology) do
      I18n.with_locale(:en) { create(:technology, technology_group:, position: 0) }
    end
    let!(:second_technology) do
      I18n.with_locale(:en) { create(:technology, technology_group:, position: 1) }
    end

    context 'when admin run sort technology_group screenshots function' do
      let(:params) { { technology_id: technology.id, row_position: second_technology.position } }

      it 'is sort technology_group screenshots' do
        expect do
          put "/admin/technology_groups/#{technology_group.id}/sort_technologies",
              params: { technology_group: params }, as: :json
        end.to(change { technology.reload.position }.from(0))

        expect(technology.reload.position).not_to eq(0)
      end
    end
  end
end
