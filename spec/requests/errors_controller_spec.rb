RSpec.describe ErrorsController, type: :request do
  context 'when visit not-found path' do
    it 'is return 404 status code' do
      get '/not-found'
      expect(response.status).to be_eql(404)
    end
  end
end
