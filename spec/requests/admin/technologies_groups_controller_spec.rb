RSpec.describe Admin::TechnologyGroupsController, type: :request do
  before do
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
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
          put "/admin/technology_groups/#{technology_group.id}", params: { technology_group: { title: '' } }
        end.not_to(change { TechnologyGroup.first.title })
      end
    end
  end

  describe '#update position' do
    let!(:technology_group) { create(:technology_group, position: 1) }
    let!(:second_technology_group) { create(:technology_group, position: 0) }

    context 'when admin update technology_group position' do
      let(:params) { { technology_group_id: technology_group.id, row_position: second_technology_group.position } }

      it 'is update technology_group position' do
        expect do
          put '/admin/technology_groups/update_position', params: { technology_group: params }
        end.to(change { TechnologyGroup.first.position })
      end
    end
  end

  describe '#sort technologies' do
    let!(:technology) { create(:technology, position: 1) }

    context 'when admin run sort technology_group screenshots function' do
      let(:params) { { technology_id: technology.id, row_position: 0 } }

      it 'is sort technology_group screenshots' do
        expect do
          put "/admin/technology_groups/#{technology.id}/sort_technologies",
              params: { technology_group: params }
        end.to(change { Technology.first.position })
      end
    end
  end
end
