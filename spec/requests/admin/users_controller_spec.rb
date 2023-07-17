RSpec.describe Admin::UsersController, type: :request do
  before do
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
  end

  describe '#update' do
    let!(:user) { create(:user) }

    context 'when params valid' do
      let(:params) { attributes_for(:user) }

      it 'is update user email' do
        expect do
          put "/admin/users/#{user.id}", params: { user: params }
        end.to(change { User.first.email })
      end
    end

    context 'when invalid params' do
      it 'is not update user name' do
        expect do
          put "/admin/users/#{user.id}", params: { user: { email: '' } }
        end.not_to(change { User.first.email })
      end
    end
  end
end
