require 'rails_helper'

describe 'Pages routing' do
    
  it 'route /main to the pages controller' do
    expect(get: '/main').to route_to(controller: 'pages', action: 'showbyshortlink', shortlink: 'main')
  end

end
