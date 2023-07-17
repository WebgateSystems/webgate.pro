RSpec.describe ContactsController, type: :request do
  context 'when valid params' do
    let(:contact) { attributes_for(:contact) }

    it 'is create contact' do
      post '/contacts', params: { contact: }
      expect(response.status).to be_eql(302)
    end
  end

  # context 'when visit contact new path' do
  #   it 'is render new contact template' do
  #     get '/new_contact'
  #     expect(response).to be_successful
  #   end
  # end

  # context 'when params invalid' do
  #   let(:contact) { attributes_for(:contact, email: '') }

  #   it 'is not create contact message' do
  #     post '/contacts', params: { contact: }
  #     expect(binding.pry).to be_eql(422)
  #   end
  # end
end
