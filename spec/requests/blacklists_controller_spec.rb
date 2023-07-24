RSpec.describe BlacklistsController, type: :request do
  context 'when visit blacklist path' do
    it 'is render blaclist template' do
      get '/blacklist'
      expect(response).to be_successful
    end
  end

  context 'when add user to blacklist' do
    it 'is add user to blacklist' do
      post '/blacklists'
      expect(response).to be_successful
    end
  end
end
