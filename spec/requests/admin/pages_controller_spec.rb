RSpec.describe Admin::PagesController, type: :request do
  before do
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
  end

  context 'when valid params' do
    let!(:page) { create(:page) }
    let(:params) { attributes_for(:page).except(:category) }

    it 'is update page shortlink' do
      expect do
        put("/admin/pages/#{page.id}", params: { page: params })
      end.to(change { Page.first.shortlink })
    end

    it 'is update page title' do
      expect do
        put("/admin/pages/#{page.id}", params: { page: params })
      end.to(change { Page.first.title })
    end

    it 'is update page description' do
      expect do
        put("/admin/pages/#{page.id}", params: { page: params })
      end.to(change { Page.first.description })
    end

    it 'is update page keywords' do
      expect do
        put("/admin/pages/#{page.id}", params: { page: params })
      end.to(change { Page.first.keywords })
    end

    it 'is update page content' do
      expect do
        put("/admin/pages/#{page.id}", params: { page: params })
      end.to(change { Page.first.content })
    end
  end

  context 'when params invalid' do
    let!(:page) { create(:page) }
    let(:params) { { title: '' } }

    it 'is not update page shortlink' do
      expect do
        put("/admin/pages/#{page.id}", params: { page: params })
      end.not_to(change { Page.first.title })
    end
  end
end
