RSpec.describe Admin::PagesController, type: :request do
  before do
    I18n.locale = :en
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
  end

  context 'when valid params' do
    let!(:page) do
      I18n.with_locale(:en) do
        create(:page)
      end
    end
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
    let!(:page) do
      I18n.with_locale(:en) do
        create(:page)
      end
    end
    let(:params) { { title: nil } }

    it 'is not update page title' do
      I18n.with_locale(:en) do
        original_title = Page.find(page.id).title
        put("/admin/pages/#{page.id}", params: { page: params })
        I18n.with_locale(:en) do
          expect(Page.find(page.id).title).to eq(original_title)
        end
      end
    end
  end
end
