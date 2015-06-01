require 'rails_helper'

describe 'Pages routing' do

  it 'route /about-test to the pages controller' do
    expect(get: '/about-test').to route_to(controller: 'pages', action: 'showbyshortlink', shortlink: 'about-test')
  end

end
