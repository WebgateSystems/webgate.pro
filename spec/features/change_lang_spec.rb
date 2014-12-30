require 'rails_helper'

feature 'Change language' do

  scenario 'User change to PL language' do
    visit root_path
    click_link('pl')
    expect(page).to have_text 'Zmień język'
  end

  scenario 'User change to EN language' do
    visit root_path
    click_link('en')
    expect(page).to have_text 'Change language'
  end

  scenario 'User change to RU language' do
    visit root_path
    click_link('ru')
    expect(page).to have_text 'Изменить язык'
  end

end