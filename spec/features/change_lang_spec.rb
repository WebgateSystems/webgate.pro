require 'rails_helper'
require 'sass'

feature 'Change language' do

  ['pl', 'en', 'ru'].each do |lang|
    scenario "User change to #{lang} language" do
      visit root_path
      click_link(lang) unless I18n.locale.to_s == lang
      expect(page).to have_text 'Zmień język'     if lang == 'pl'
      expect(page).to have_text 'Change language' if lang == 'en'
      expect(page).to have_text 'Изменить язык'   if lang == 'ru'
    end
  end

end
