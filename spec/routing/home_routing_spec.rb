require 'rails_helper'

describe 'routes for localized name routes', type: :routing do
  ApplicationController::PUBLIC_LANGS.map(&:first).each do |l|
    it 'localized routes to Home controller' do
      I18n.with_locale(l) do
        expect(get: main_path).to route_to(controller: 'home', action: 'index', locale: l)
        expect(get: portfolio_path).to route_to(controller: 'home', action: 'portfolio', locale: l)
      end
    end
  end
end
