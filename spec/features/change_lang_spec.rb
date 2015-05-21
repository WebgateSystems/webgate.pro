require 'rails_helper'
require 'sass'
include ApplicationHelper

feature 'Change language' do

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
      expect(current_path).to eq team_pl_path if lang == 'pl'
      expect(current_path).to eq team_ru_path if lang == 'ru'
    end
  end

end
