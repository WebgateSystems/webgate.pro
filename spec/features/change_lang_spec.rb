require 'rails_helper'

feature 'Change language' do

  scenario 'User change to PL language' do
    visit root_path
    click_link('pl') unless I18n.locale.to_s == 'pl'
    expect(page).to have_text 'Zmień język'
  end

  scenario 'User change to EN language' do
    visit root_path   
    click_link('en') unless I18n.locale.to_s == 'en'
    expect(page).to have_text 'Change language'
  end

  scenario 'User change to RU language' do
    visit root_path
    click_link('ru') unless I18n.locale.to_s == 'ru'
    expect(page).to have_text 'Изменить язык'
  end

end