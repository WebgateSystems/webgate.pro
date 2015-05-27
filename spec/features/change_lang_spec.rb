require 'rails_helper'
require 'sass'
include ApplicationHelper

feature 'Change language' do

  let!(:category) { create(:category) }
  let!(:en_page) { create(:en_page) }

  before do
    I18n.locale = 'pl'
    category.update(name: 'O nas', altlink: 'o-nas')
    en_page.update(title: 'O nas', shortlink: category.altlink)
    I18n.locale = 'ru'
    category.update(name: 'О нас', altlink: 'о-нас')
    en_page.update(title: 'О нас', shortlink: category.altlink)
    I18n.locale = 'en'
    category.update(name: 'About', altlink: 'about')
    en_page.update(title: 'About', shortlink: category.altlink)
  end

  scenario 'User change language on root url' do
    other_public_langs.each do |lang|
      visit root_path
      within '.lang' do
        click_link(lang.upcase)
      end
      expect(page).to have_text 'Zmień język' if lang == 'pl'
      expect(page).to have_text 'Изменить язык' if lang == 'ru'
    end
  end

  scenario 'User change language on localized routes pages' do
    other_public_langs.each do |lang|
      visit team_path
      within '.lang' do
        click_link(lang.upcase)
      end
      expect(current_path).to eq eval("team_#{lang}_path")
    end
  end

  scenario 'User change language on pages with shortlink', js: true do
    other_public_langs.each do |lang|
      visit "/#{en_page.shortlink}"
      within '.lang' do
        click_link(lang.upcase)
      end
      Globalize.with_locale(lang) do
        expect(page).to have_content en_page.title
      end
    end
  end

  scenario 'Check active class on current page' do
    en_page.update(shortlink: category.altlink)
    visit "/#{en_page.shortlink}"
    expect(page).to have_css ('.top_nav li.active')
  end

end
