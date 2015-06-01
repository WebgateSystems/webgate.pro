require 'rails_helper'

feature 'Category in admin panel.' do
  def lang_change
    I18n.locale = 'pl'
    c = Category.last
    c.name = 'PolskaName'
    c.altlink = 'PolskaAltlink'
    c.save
    I18n.locale = 'ru'
    c = Category.last
    c.name = 'RuskaName'
    c.altlink = 'RuskaAltlink'
    c.save
    I18n.locale = 'en'
    c = Category.last
    c.name = 'EnglishName'
    c.altlink = 'EnglishAltlink'
    c.save
  end

  let(:user) { create(:user) }

  before do
    sign_in(user)
    visit admin_categories_path
    3.times do |t|
      click_link ('New')
      fill_in 'category[name]', with: "TestTitle#{t}"
      fill_in 'category[altlink]', with: "TestLink#{t}"
      fill_in 'category[description]', with: "TestDesc#{t}"
      click_button 'Save'
      visit admin_categories_path
    end
  end

  scenario 'Category root path should have list of categories' do
    visit admin_categories_path
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Altlink'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'TestTitle1'
    expect(page).to have_content 'TestTitle2'
  end

  scenario 'Try drag and drop on index', js: true do
    visit admin_categories_path
    dest_element = find('td', text: 'TestTitle2')
    source_element = find('td', text: 'TestTitle1')
    source_element.drag_to dest_element
    sleep 5 # wait for ajax complete
    page.all(:link, 'Show')[1].click
    expect(current_path).to eq admin_category_path(Category.last.id)
    visit admin_categories_path
    page.all(:link, 'Show')[2].click
    expect(current_path).to_not eq admin_category_path(Category.last.id)
  end

  scenario 'Link list should work good' do
    visit new_admin_category_path
    click_link('List')
    expect(current_path).to eq admin_categories_path
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq new_admin_category_path
  end

  scenario 'Categoryt root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(current_path).to eq admin_category_path(Category.first.id)
    visit admin_categories_path
    page.all(:link, 'Edit')[0].click
    expect(current_path).to eq edit_admin_category_path(Category.first.id)
  end

  scenario 'Link delete should delete category' do
    page.all(:link, 'Delete')[0].click
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our category information' do
    click_link ('TestTitle0')
    expect(page).to have_content 'Name:'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'Altlink:'
    expect(page).to have_content 'TestLink0'
    expect(page).to have_content 'Description:'
    expect(page).to have_content 'TestDesc0'
  end

  scenario 'Create category should create category' do
    click_link ('New')
    fill_in 'category[name]', with: 'TestTitleFull'
    fill_in 'category[altlink]', with: 'TestlinkFull'
    fill_in 'category[description]', with: 'TestDescFull'
    click_button 'Save'
    visit admin_categories_path
    expect(page).to have_content 'TestTitleFull'
  end

  scenario 'Validation for new category' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  scenario 'Dont create category with empty fields' do
    click_link ('New')
    fill_in 'category[name]', with: 'TestTitlekukumba'
    visit admin_categories_path
    expect(page).to have_no_content 'TestTitlekukumba'
  end

  scenario 'Now link should be same that we create' do
    ['pl', 'ru'].each do |lang|
      visit root_path
      click_link(lang) unless I18n.locale.to_s == lang
      first(:link, Category.last.name).click
      expect(current_path).to eq "/#{Category.last.altlink}"
    end
  end

  scenario 'Now name should be the same that we create, but in another language' do
    visit root_path
    ['pl', 'ru'].each do |lang|
      click_link(lang) unless I18n.locale.to_s == lang
      expect(page).to have_content Category.last.name
    end
  end

  scenario 'Should translate and display this menu, on all languages.' do
    lang_change
    visit root_path
    ['en', 'pl', 'ru'].each do |lang|
      click_link(lang) unless I18n.locale.to_s == lang
      expect(page).to have_content 'PolskaName' if lang == 'pl'
      expect(page).to have_content 'RuskaName' if lang == 'ru'
      expect(page).to have_content 'EnglishName' if lang == 'en'
    end
  end

  scenario 'Should translate altlink on all languages.' do
    lang_change
    ['en', 'pl', 'ru'].each do |lang|
      visit root_path
      click_link(lang) unless I18n.locale.to_s == lang
      first(:link, 'PolskaName').click if lang == 'pl'
      first(:link, 'RuskaName').click if lang == 'ru'
      first(:link, 'EnglishName').click if lang == 'en'
      expect(current_path).to eq '/PolskaAltlink' if lang == 'pl'
      expect(current_path).to eq '/RuskaAltlink' if lang == 'ru'
      expect(current_path).to eq '/EnglishAltlink' if lang == 'en'
    end
  end

  scenario 'Check active class on current page' do
    visit "/#{Category.last.altlink}"
    expect(page).to have_css ('.top_nav li.active')
  end
end
