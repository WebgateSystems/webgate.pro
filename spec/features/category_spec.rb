require 'rails_helper'

describe 'Category in admin panel.' do
  let(:user) { create(:user) }
  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }

  before do
    sign_in(user)
    visit admin_categories_path
  end

  it 'Category root path should have list of categories' do
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Altlink'
    expect(page).to have_content 'Created at'
    expect(page).to have_content category_1.name
    expect(page).to have_content category_2.name
  end

  # it 'Try drag and drop on index' do
  #   click_link('New')
  #   fill_in 'category[name]', with: 'TestTitleLast'
  #   fill_in 'category[altlink]', with: 'TestLinkLast'
  #   fill_in 'category[description]', with: 'TestDescLast'
  #   click_button 'Save'
  #   visit admin_categories_path
  #   dest_element = find('td', text: 'TestTitleLast')
  #   source_element = find('td', text: category_2.name)
  #   source_element.drag_to dest_element
  #   sleep 2
  #   page.all(:link, 'Show')[1].click
  #   expect(page).to have_current_path admin_category_path(Category.find_by(position: 1).id), ignore_query: true
  #   visit admin_categories_path
  #   page.all(:link, 'Show')[2].click
  #   expect(page).to have_no_current_path admin_category_path(Category.find_by(position: 1).id), ignore_query: true
  # end

  it 'Link list should work good' do
    visit new_admin_category_path
    click_link('List')
    expect(page).to have_current_path admin_categories_path, ignore_query: true
  end

  it 'Category root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(page).to have_current_path admin_category_path(Category.first.id), ignore_query: true
    visit admin_categories_path
    page.all(:link, 'Edit')[0].click
    expect(page).to have_current_path edit_admin_category_path(Category.first.id), ignore_query: true
  end

  it 'Link delete should delete category' do
    page.all(:link, 'Delete')[0].click
    expect(page).to have_current_path current_path, ignore_query: true
  end

  # scenario 'Show should display our category information' do
  #   click_link(category_1.name)
  #   expect(page).to have_content 'Name:'
  #   expect(page).to have_content category_1.name
  #   expect(page).to have_content 'Altlink:'
  #   expect(page).to have_content category_1.altlink
  #   expect(page).to have_content 'Description:'
  #   expect(page).to have_content category_1.description
  # end

  it 'Create category should create category' do
    click_link('New')
    fill_in 'category[name]', with: 'TestTitleFull'
    fill_in 'category[altlink]', with: 'TestlinkFull'
    fill_in 'category[description]', with: 'TestDescFull'
    click_button 'Save'
    visit admin_categories_path
    expect(page).to have_content 'TestTitleFull'
  end

  it 'Validation for new category' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end
