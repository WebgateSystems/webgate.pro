# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'cache tasks', type: :task do
  before do
    Rake.application.rake_require 'tasks/cache'
    Rake::Task.define_task(:environment)
  end

  after do
    Rake::Task['cache:clear'].reenable
    Rake::Task['cache:expire_members'].reenable
    Rake::Task['cache:expire_projects'].reenable
    Rake::Task['cache:expire_all'].reenable
  end

  describe 'cache:clear' do
    it 'clears Rails cache' do
      Rails.cache.write('test_key', 'test_value')
      expect(Rails.cache.read('test_key')).to eq('test_value')

      Rake::Task['cache:clear'].invoke

      expect(Rails.cache.read('test_key')).to be_nil
    end
  end

  describe 'cache:expire_members' do
    it 'expires cache for members page' do
      helper = Object.new.extend(HomeHelper)
      # Store cache keys before they might change
      cache_keys = {}
      I18n.available_locales.each do |locale|
        I18n.with_locale(locale) do
          cache_keys[locale] = helper.cache_key_for_members
        end
        Rails.cache.write([cache_keys[locale], { locale: }], 'cached_value')
      end

      Rake::Task['cache:expire_members'].reenable
      Rake::Task['cache:expire_members'].invoke

      I18n.available_locales.each do |locale|
        expect(Rails.cache.read([cache_keys[locale], { locale: }])).to be_nil
      end
    end
  end

  describe 'cache:expire_projects' do
    it 'expires cache for projects page' do
      helper = Object.new.extend(HomeHelper)
      cache_keys = {}
      I18n.available_locales.each do |locale|
        I18n.with_locale(locale) do
          cache_keys[locale] = helper.cache_key_for_projects
        end
        Rails.cache.write([cache_keys[locale], { locale: }], 'cached_value')
      end

      Rake::Task['cache:expire_projects'].reenable
      Rake::Task['cache:expire_projects'].invoke

      I18n.available_locales.each do |locale|
        expect(Rails.cache.read([cache_keys[locale], { locale: }])).to be_nil
      end
    end
  end

  describe 'cache:expire_all' do
    it 'expires all page caches' do
      helper = Object.new.extend(HomeHelper)
      # Store cache keys before they might change
      cache_keys = {}
      I18n.available_locales.each do |locale|
        I18n.with_locale(locale) do
          cache_keys[locale] = {
            members: helper.cache_key_for_members,
            projects: helper.cache_key_for_projects
          }
        end
        Rails.cache.write([cache_keys[locale][:members], { locale: }], 'cached_value')
        Rails.cache.write([cache_keys[locale][:projects], { locale: }], 'cached_value')
      end

      Rake::Task['cache:expire_all'].reenable
      Rake::Task['cache:expire_all'].invoke

      I18n.available_locales.each do |locale|
        expect(Rails.cache.read([cache_keys[locale][:members], { locale: }])).to be_nil
        expect(Rails.cache.read([cache_keys[locale][:projects], { locale: }])).to be_nil
      end
    end
  end
end
