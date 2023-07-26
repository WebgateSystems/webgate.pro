RSpec.describe ErrorsController, type: :request do
  context 'when visit not-found path' do
    it 'is return 404 status code' do
      get '/not-found'
      expect(response.status).to be_eql(404)
    end
  end

  context 'when visit 422 path' do
    it 'is return 422 status code' do
      get '/422'
      expect(response.status).to be_eql(422)
    end
  end

  context 'when visit 500 path' do
    it 'is return 500 status code' do
      get '/500'
      expect(response.status).to be_eql(500)
    end
  end
end
