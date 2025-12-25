require 'rails_helper'

describe HomeController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers

  describe "GET 'index'" do
    it 'returns http success' do
      get :index
      expect(response).to be_ok
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe "GET 'portfolio'" do
    it 'orders projects by published_on (fallback created_at) descending' do
      collage = Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/body.jpg').to_s)

      p3 = travel_to(Time.zone.parse('2024-01-01 10:00:00')) do
        I18n.with_locale(:en) do
          Project.create!(
            title: 'P3', content: 'C3', livelink: 'http://test.webgate.pro', publish: true,
            collage:
          )
        end
      end

      p2 = travel_to(Time.zone.parse('2025-12-24 10:00:00')) do
        I18n.with_locale(:en) do
          Project.create!(
            title: 'P2', content: 'C2', livelink: 'http://test.webgate.pro', publish: true,
            collage:
          )
        end
      end

      p1 = travel_to(Time.zone.parse('2025-12-20 10:00:00')) do
        I18n.with_locale(:en) do
          Project.create!(
            title: 'P1', content: 'C1', livelink: 'http://test.webgate.pro', publish: true,
            published_on: Date.new(2025, 12, 25),
            collage:
          )
        end
      end

      I18n.locale = :en
      get :portfolio, params: { locale: 'en' }

      ids = assigns(:projects).map(&:id)
      expect(ids).to eq([p1.id, p2.id, p3.id])
    end
  end
end
