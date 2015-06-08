require 'rails_helper'

describe 'routes for Pages' do
  ApplicationController::PUBLIC_LANGS.map(&:first).each do |l|
    it 'localized pages to Page controller' do
      I18n.with_locale(l) do
        Page.published.with_translations(l) do |page|
          expect(get: page.shortlink).to route_to('pages#showbyshortlink')
        end
      end
    end
  end
end
