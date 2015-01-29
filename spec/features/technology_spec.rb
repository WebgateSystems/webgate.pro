require 'rails_helper'

feature 'Technology in admin panel.' do
  let(:user) { create(:user) }
  before do
    visit '/admin'
    login_user_post(user.email, 'secret')
    visit '/admin/technology_groups'
    click_link ('New')
    fill_in 'technology_group[title]', with: 'TestGroup'
    fill_in 'technology_group[description]', with: 'Test Description'
    click_button 'Save'
    visit '/admin/technologies'
    click_link ('New')
    find('#technology_technology_group_id').find(:xpath, 'option[1]').select_option
    fill_in 'technology[title]', with: 'TestTitle'
    fill_in 'technology[description]', with: 'TestDesc'
    click_button 'Save'
    visit '/admin/technologies'
  end


  scenario 'Link list should work good' do
    click_link('List')
    expect(current_path).to eq '/admin/technologies'
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq '/admin/technologies/new'
  end

  scenario 'Page root path should have list of pages' do
    expect(page).to have_content 'ID'
    expect(page).to have_content 'Technology group title'
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'Actions'
  end

  scenario 'Page root path should have our page name' do
    expect(page).to have_content 'TestTitle'
  end

  scenario 'Page root path links show, edit should work' do
    page.all(:link,'Show')[0].click
    expect(current_path).to eq "/admin/technologies/#{Technology.last.id}"
    visit '/admin/technologies'
    page.all(:link,'Edit')[0].click
    expect(current_path).to eq "/admin/technologies/#{Technology.last.id}/edit"
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
  end

  scenario 'Create page should create page' do
    click_link ('New')
    fill_in 'technology[title]', with: 'TestTitleFull'
    fill_in 'technology[description]', with: 'PewPewPew'
    click_button 'Save'
    visit '/admin/technologies'
    expect(page).to have_content 'TestTitleFull'
  end

  scenario 'technology group must displays in index' do
    expect(page).to have_content 'TestGroup'
  end

  scenario 'validation for new technology' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end