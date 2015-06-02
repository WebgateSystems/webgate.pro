require 'rails_helper'

describe PagesController do

  before :each do
    @page = create(:en_page)
  end

  describe "GET 'showbyshortlink'" do
    it 'returns http success' do
      get :showbyshortlink, shortlink: @page.shortlink
      expect(response).to be_success
    end

    it 'renders the template' do
      get :showbyshortlink, shortlink: @page.shortlink
      expect(response).to render_template('showbyshortlink')
    end

    it 'redirect to not_found url when page is not found' do
      get :showbyshortlink, shortlink: 'blabla'
      expect(response).to redirect_to('/not-found')
      expect(response).to have_http_status(302)
    end
  end
end
