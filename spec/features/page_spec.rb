require 'rails_helper'

feature 'Page in admin panel.' do
  let(:user) { create(:user) }
  let!(:en_page) { create(:en_page)}

  before do
    sign_in(user)
    visit admin_pages_path
  end

  scenario 'Link list should work good' do
    visit new_admin_page_path
    click_link('List')
    expect(current_path).to eq admin_pages_path
  end

  scenario 'Page root path should have list of pages' do
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
    expect(page).to have_content en_page.title
  end

  scenario 'Page root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(current_path).to eq admin_page_path(Page.first.id)
    visit admin_pages_path
    page.all(:link, 'Edit')[0].click
    expect(current_path).to eq edit_admin_page_path(Page.first.id)
  end

  scenario 'Link delete should delete page' do
    page.all(:link, 'Delete')[0].click
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our page information' do
    click_link(en_page.title)
    expect(page).to have_content 'Title:'
    expect(page).to have_content en_page.title
    expect(page).to have_content 'Description:'
    expect(page).to have_content en_page.description
    expect(page).to have_content 'Shortlink:'
    expect(page).to have_content 'Keywords:'
    expect(page).to have_content 'Content:'
    expect(page).to have_content en_page.shortlink
    expect(page).to have_content en_page.keywords
    expect(page).to have_content en_page.content
  end

  scenario 'Create page should create page' do
    click_link('New')
    fill_in 'page[title]', with: 'TestTitleFull'
    fill_in 'page[shortlink]', with: 'TestlinkFull'
    fill_in 'page[description]', with: 'TestDescFull'
    fill_in 'page[keywords]', with: 'TestKeyWordFull'
    fill_in 'page[content]', with: 'TestContentFull'
    click_button 'Save'
    visit admin_pages_path
    expect(page).to have_content 'TestTitleFull'
  end

  scenario 'Validation for new page' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end
