RSpec.describe Admin::TechnologiesController, type: :request do
  before do
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
  end

  describe '#new' do
    let(:group) { create(:technology_group) }

    it 'is render new technology template' do
      get '/admin/technologies/new', params: { technology_group_id: group.id }
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context 'when params valid' do
      let(:params) { attributes_for(:technology) }
      let(:return_params) do
        { 'pl' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
          'en' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
          'ru' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
          'fr' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
          'ua' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil } }
      end

      before do
        allow_any_instance_of(AddTranslation).to receive(:answer_gpt).and_return(return_params)
      end

      it 'is create technology' do
        expect do
          post '/admin/technologies', params: { technology: params }
        end.to(change(Technology, :count))
      end
    end

    context 'when invalid params' do
      it 'is create technology' do
        expect do
          post '/admin/technologies', params: { technology: { title: '' } }
        end.not_to(change(Technology, :count))
      end
    end
  end

  describe '#update' do
    let!(:technology) { create(:technology) }

    context 'when params valid' do
      let(:params) { attributes_for(:technology).except(:technology_group) }

      it 'is update technology title' do
        expect do
          put "/admin/technologies/#{technology.id}", params: { technology: params }
        end.to(change { Technology.first.title })
      end

      it 'is update technology link' do
        expect do
          put "/admin/technologies/#{technology.id}", params: { technology: params }
        end.to(change { Technology.first.link })
      end

      it 'is update technology description' do
        expect do
          put "/admin/technologies/#{technology.id}", params: { technology: params }
        end.to(change { Technology.first.description })
      end
    end

    context 'when invalid params' do
      it 'is update technology title' do
        expect do
          put "/admin/technologies/#{technology.id}", params: { technology: { title: nil } }
        end.not_to(change { Technology.first.title })
      end
    end
  end

  describe '#destroy' do
    let!(:technology) { create(:technology) }

    context 'when admin want to destroy technology' do
      it 'is delete technology' do
        expect do
          delete "/admin/technologies/#{technology.id}"
        end.to change(Technology, :count).from(1).to(0)
      end
    end
  end
end
