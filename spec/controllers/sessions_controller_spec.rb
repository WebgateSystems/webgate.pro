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

  describe "GET 'destroy'" do
    it 'logs out and redirects to root' do
      allow(controller).to receive(:logout).and_return(true)

      get :destroy

      expect(controller).to have_received(:logout)
      expect(response).to redirect_to(root_url)
    end
  end
end
