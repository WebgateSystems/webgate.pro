require 'rails_helper'

describe Page::ApplicationController do
  describe 'pages routing' do
    
    it 'routes /main to the pages controller' do
      expect(get: '/main').to route_to(controller: 'pages', action: 'showbyshortlink', shortlink: 'main')
    end
    
    it 'routes /not-found to the pages controller' do
      expect(get: '/not-found').to route_to('pages#not_found')
    end

  end
end
