require 'rails_helper'

feature 'Page in admin panel.' do
  let(:user) { create(:user) }
  before do
    visit '/admin'
    login_user_post(user.email, 'secret')
    visit '/admin/pages'
    click_link ('New')
    fill_in 'page[title]', with: 'TestTitle'
    fill_in 'page[shortlink]', with: 'Testlink'
    fill_in 'page[description]', with: 'TestDesc'
    fill_in 'page[keywords]', with: 'TestKeyWord'
    fill_in 'page[content]', with: 'TestContent'
    click_button 'Save'
    visit '/admin/pages'
  end


  scenario 'Link list should work good' do
    click_link('List')
    expect(current_path).to eq '/admin/pages'
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq '/admin/pages/new'
  end

  scenario 'Page root path should have list of pages' do
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
  end

  scenario 'Page root path should have our page name' do
    expect(page).to have_content 'TestTitle'
  end

  scenario 'Page root path links show, edit should work' do
    page.all(:link,'Show')[0].click
    expect(current_path).to eq "/admin/pages/#{Page.last.id}"
    visit '/admin/pages'
    page.all(:link,'Edit')[0].click
    expect(current_path).to eq "/admin/pages/#{Page.last.id}/edit"
  end

  scenario 'link delete should delete page' do
    page.all(:link,'Delete')[0].click
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our page information' do
    click_link ('TestTitle')
    expect(page).to have_content 'Title:'
    expect(page).to have_content 'TestTitle'
    expect(page).to have_content 'Description:'
    expect(page).to have_content 'TestDesc'
    expect(page).to have_content 'Shortlink:'
    expect(page).to have_content 'Keywords:'
    expect(page).to have_content 'Content:'
    expect(page).to have_content 'Testlink'
    expect(page).to have_content 'TestKeyWord'
    expect(page).to have_content 'TestContent'
  end

  scenario 'Create page should create page' do
    click_link ('New')
    fill_in 'page[title]', with: 'TestTitleFull'
    fill_in 'page[shortlink]', with: 'Testlink1'
    fill_in 'page[description]', with: 'TestDesc1'
    fill_in 'page[keywords]', with: 'TestKeyWord1'
    fill_in 'page[content]', with: 'TestContent1'
    click_button 'Save'
    visit '/admin/pages'
    expect(page).to have_content 'TestTitleFull'
  end

  scenario 'Created page should have work link' do
    visit '/Testlink'
    expect(page).to have_content 'Lorem ipsum dolor sit amet'
  end

  scenario 'When we create page, if some fields empty, we need to see error message' do
    click_link ('New')
    fill_in 'page[title]', with: 'TestTitleFull'
    fill_in 'page[shortlink]', with: 'Testlink1'
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  scenario 'validation for new page' do
    click_link ('New')
    fill_in 'page[title]', with: 'TestTitleFull'
    fill_in 'page[description]', with: 'TestDesc1'
    fill_in 'page[keywords]', with: 'TestKeyWord1'
    fill_in 'page[content]', with: 'TestContent1'
    click_button 'Save'
    expect(page).to have_css('#page_title')
  end
end
