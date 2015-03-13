require 'rails_helper'

feature 'Category in admin panel.' do

  let(:user) { create(:user) }

  before do
    sign_in(user)
    visit '/admin/categories'
    3.times do |t|
      click_link ('New')
      fill_in 'category[name]', with: "TestTitle#{t}"
      fill_in 'category[altlink]', with: "TestLink#{t}"
      fill_in 'category[description]', with: "TestDesc#{t}"
      click_button 'Save'
      visit '/admin/categories'
    end
  end

  scenario 'Category root path should have list of categories' do
    visit '/admin/categories'
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Altlink'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'TestTitle1'
    expect(page).to have_content 'TestTitle2'
  end

  scenario 'Try drag and drop on index', js: true do
    visit '/admin/categories'
    dest_element = find('td', text: "TestTitle2")
    source_element = find('td', text: "TestTitle1")
    source_element.drag_to dest_element
    sleep 5 #wait for ajax complete
    page.all(:link, 'Show')[1].click
    expect(current_path).to eq "/admin/categories/#{Category.last.id}"
    visit '/admin/categories'
    page.all(:link, 'Show')[2].click
    expect(current_path).to_not eq "/admin/categories/#{Category.last.id}"
  end

  scenario 'Link list should work good' do
    click_link('List')
    expect(current_path).to eq '/admin/categories'
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq '/admin/categories/new'
  end

  scenario 'Categoryt root path links show, edit should work' do
    page.all(:link,'Show')[0].click
    expect(current_path).to eq "/admin/categories/#{Category.first.id}"
    visit '/admin/categories'
    page.all(:link,'Edit')[0].click
    expect(current_path).to eq "/admin/categories/#{Category.first.id}/edit"
  end

  scenario 'Link delete should delete category' do
    page.all(:link,'Delete')[0].click
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
    fill_in 'category[name]', with: "TestTitleFull"
    fill_in 'category[altlink]', with: "TestlinkFull"
    fill_in 'category[description]', with: "TestDescFull"
    click_button 'Save'
    visit '/admin/categories'
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
    visit '/admin/categories'
    expect(page).to have_no_content 'TestTitlekukumba'
  end

end
