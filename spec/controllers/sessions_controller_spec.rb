describe SessionsController, type: :controller do
  describe "GET 'new'" do
    it 'returns http success' do
      get :new
      expect(response).to be_ok
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end
end
