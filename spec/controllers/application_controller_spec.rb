# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'ok'
    end
  end

  before do
    routes.draw { get 'index' => 'anonymous#index' }
  end

  describe 'language selection helpers' do
    it 'accepts russian language when user_accepted param is provided' do
      get :index, params: { user_accepted: '1', locale: 'ru' }
      expect(cookies[:lang_accepted]).to eq('true')
    end

    it 'maps geoip country codes to locales' do
      allow(Bundler).to receive(:require).with('geoip')
      geoip_class = Class.new do
        def initialize(_path); end

        def country(_ip); end
      end
      stub_const('GeoIP', geoip_class)
      allow(controller.request).to receive(:remote_ip).and_return('127.0.0.1')

      country_struct = Struct.new(:country_code2)
      calls = 0
      allow_any_instance_of(GeoIP).to receive(:country) do
        calls += 1
        code = %w[DE PL UA RU].fetch(calls - 1)
        country_struct.new(code)
      end
      expect(controller.send(:geoip_lang)).to eq('de')

      expect(controller.send(:geoip_lang)).to eq('pl')

      expect(controller.send(:geoip_lang)).to eq('ua')

      expect(controller.send(:geoip_lang)).to eq('ru')
    end
  end
end
