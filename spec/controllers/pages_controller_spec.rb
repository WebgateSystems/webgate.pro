describe PagesController, type: :request do
  let!(:en_page) { create(:en_page) }

  describe "GET 'showbyshortlink'" do

    it 'returns http success' do
      get "/#{en_page.shortlink}"
      expect(response).to be_success
    end

    it 'renders the template' do
      get "/#{en_page.shortlink}"
      expect(response).to render_template('showbyshortlink')
    end

    it 'redirect to not_found url when page is not found' do
      get '/not_exist_url'
      expect(response).to redirect_to('/not-found')
    end

    # it 'returns http success' do
    #   get :showbyshortlink, shortlink: en_page.shortlink
    #   expect(response).to be_success
    # end

    # it 'renders the template' do
    #   get :showbyshortlink, shortlink: en_page.shortlink
    #   expect(response).to render_template('showbyshortlink')
    # end

    # it 'redirect to not_found url when page is not found' do
    #   get :showbyshortlink, shortlink: 'blabla'
    #   expect(response).to redirect_to('/not-found')
    #   expect(response).to have_http_status(302)
    # end
  end
end
