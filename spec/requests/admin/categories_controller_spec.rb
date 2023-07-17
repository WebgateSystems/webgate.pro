RSpec.describe Admin::CategoriesController, type: :request do
  before do
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
  end

  describe '#update' do
    let!(:category) { create(:category) }

    context 'when params valid' do
      let(:params) { attributes_for(:category) }

      it 'is update category name' do
        expect do
          put "/admin/categories/#{category.id}", params: { category: params }
        end.to(change { Category.first.name })
      end

      it 'is update category description' do
        expect do
          put "/admin/categories/#{category.id}", params: { category: params }
        end.to(change { Category.first.altlink })
      end
    end

    context 'when invalid params' do
      it 'is not update category name' do
        expect do
          put "/admin/categories/#{category.id}", params: { category: { name: '' } }
        end.not_to(change { Category.first.name })
      end
    end
  end

  describe '#update position' do
    let!(:category) { create(:category, position: 1) }
    let!(:second_category) { create(:category, position: 0) }

    context 'when admin update category position' do
      let(:params) { { category_id: category.id, row_position: second_category.position } }

      it 'is update category position' do
        expect do
          put '/admin/categories/update_position', params: { category: params }
        end.to(change { Category.first.position })
      end
    end
  end
end
