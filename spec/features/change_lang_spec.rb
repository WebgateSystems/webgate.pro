require 'rails_helper'
require 'sass'
include ApplicationHelper

describe 'Change language' do
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

  # scenario 'User change language on root url' do
  #   other_public_langs.each do |lang|
  #     visit(main_en_path)
  #     click_link(lang.upcase)
  #     case lang
  #     when 'pl'
  #       expect(current_path).to eq main_pl_path
  #     when 'ru'
  #       expect(current_path).to eq main_ru_path
  #     else
  #       expect(page).to have_text 'add new language to this test' if lang
  #     end
  #   end
  # end

  ############################ IF USE RACK TEST DRIVER

  it 'User change language on localized routes pages' do
    other_public_langs.each do |lang|
      visit team_path
      within '.lang' do
        find('.current_lang').click
        click_link(lang.upcase)
      end
      expect(page).to have_current_path team_pl_path, ignore_query: true if lang == 'pl'
      expect(page).to have_current_path team_en_path, ignore_query: true if lang == 'en'
    end
  end

  ######################################

  #########################   IF USE SELENIUM DRIVER

  # describe 'change language', js: true do
  #   context 'when change language to pl' do
  #     before do
  #       visit root_path
  #       find('.current_lang').hover
  #       find('a', text: 'PL').click
  #     end

  #     it { expect(page).to have_current_path(main_pl_path) }
  #   end

  #   context 'when change language to ru' do
  #     before do
  #       visit root_path
  #       find('.current_lang').hover
  #       find('a', text: 'RU').click
  #     end

  #     it { expect(page).to have_current_path(main_ru_path) }
  #   end
  # end

  ######################################

  # it 'User change language on pages with shortlink' do
  #   other_public_langs.each do |lang|
  #     visit "/#{en_page.shortlink}"
  #     within '.lang' do
  #       find('.current_lang').click
  #       click_link(lang.upcase)
  #     end
  #     Globalize.with_locale(lang) do
  #       binding.pry

  #       expect(page).to have_content en_page.title
  #     end
  #   end
  # end

  # scenario 'Check active class on current page' do
  #   en_page.update(shortlink: category.altlink)
  #   visit "/#{en_page.shortlink}"
  #   expect(page).to have_css('.top_nav li.active')
  # end
end
