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

    it 'render not_found template when page is not found' do
      @page.shortlink = 'blablabla'
      get :showbyshortlink, shortlink: @page.shortlink
      expect(response).to render_template('not_found')
      expect(response).to have_http_status(404)
    end
  end
end
