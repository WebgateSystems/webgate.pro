RSpec.describe Admin::ScreenshotsController, type: :request do
  before do
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
  end

  context 'when admin want to delete screenshot' do
    let!(:screenshot) { create(:screenshot) }
    let(:params) { attributes_for(:page).except(:category) }

    it 'is update page shortlink' do
      expect do
        delete "/admin/projects/#{screenshot.project.id}/screenshots/#{screenshot.id}"
      end.to(change { Screenshot.count }.from(1).to(0))
    end
  end
end
