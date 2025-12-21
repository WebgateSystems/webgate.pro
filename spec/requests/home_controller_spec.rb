# frozen_string_literal: true

RSpec.describe HomeController do
  let(:path) { '/version' }

  describe '#GET /version' do
    before do
      allow(AppIdService).to receive(:version).and_return('hash_of_the_last_commit')
      get path
    end

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'responds with AppIdService.version as a plain string' do
      expect(response.body).to eq('hash_of_the_last_commit')
    end
  end

  describe '#GET /version.json' do
    let(:version_json) { { version: 'hash_of_the_last_commit' }.to_json }

    before do
      allow(AppIdService).to receive(:version).and_return('hash_of_the_last_commit')
      get '/version.json'
    end

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'responds with JSON format' do
      expect(response.content_type).to include('application/json')
    end

    it 'responds with AppIdService.version as a plain string' do
      expect(response.body).to eq(version_json)
    end
  end

  describe '#GET /health' do
    before do
      get '/health'
    end

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'responds with OK as a plain string' do
      expect(response.body).to eq('OK')
    end
  end

  describe '#GET /' do
    before do
      get '/'
    end

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(:ok)
    end
  end
end
