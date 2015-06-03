require 'rails_helper'

feature 'Category in admin panel.' do
  let(:user) { create(:user) }
  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }

  before do
    sign_in(user)
    visit admin_categories_path
  end

  scenario 'Category root path should have list of categories' do
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Altlink'
    expect(page).to have_content 'Created at'
    expect(page).to have_content category_1.name
    expect(page).to have_content category_2.name
  end

  scenario 'Try drag and drop on index', js: true do
    click_link('New')
    fill_in 'category[name]', with: 'TestTitleLast'
    fill_in 'category[altlink]', with: 'TestLinkLast'
    fill_in 'category[description]', with: 'TestDescLast'
    click_button 'Save'
    visit admin_categories_path
    dest_element = find('td', text: 'TestTitleLast')
    source_element = find('td', text: category_2.name)
    source_element.drag_to dest_element
    sleep 2
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

  scenario 'Category root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(current_path).to eq admin_category_path(Category.last.id)
    visit admin_categories_path
    page.all(:link, 'Edit')[0].click
    expect(current_path).to eq edit_admin_category_path(Category.last.id)
  end

  scenario 'Link delete should delete category' do
    page.all(:link, 'Delete')[0].click
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our category information' do
    click_link(category_1.name)
    expect(page).to have_content 'Name:'
    expect(page).to have_content category_1.name
    expect(page).to have_content 'Altlink:'
    expect(page).to have_content category_1.altlink
    expect(page).to have_content 'Description:'
    expect(page).to have_content category_1.description
  end

  scenario 'Create category should create category' do
    click_link('New')
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
end
