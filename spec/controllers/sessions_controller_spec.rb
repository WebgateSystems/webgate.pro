require 'rails_helper'

describe SessionsController do
  describe "GET 'new'" do
    it 'returns http success' do
      get :new
      expect(response).to be_success
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end
end
