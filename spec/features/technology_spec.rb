require 'rails_helper'

feature 'Technology in admin panel.' do
  let(:user) { create(:user) }
  let!(:technology_group) { create(:technology_group) }

  before do
    visit admin_root_path
    login_user_post(user.email, 'secret')
    visit admin_technology_groups_path
    click_link ('New')
    fill_in 'technology_group[title]', with: 'TestGroup'
    fill_in 'technology_group[description]', with: 'Test Description'
    click_button 'Save'
    visit admin_technologies_path
    click_link ('New')
    find('#technology_technology_group_id').find(:xpath, 'option[1]').select_option
    fill_in 'technology[title]', with: 'TestTitle'
    fill_in 'technology[link]', with: 'http://example_tech.com/link'
    fill_in 'technology[description]', with: 'TestDesc'
    click_button 'Save'
    visit admin_technologies_path
  end

  scenario 'Link list should work good' do
    visit new_admin_technology_path
    click_link('List')
    expect(current_path).to eq admin_technologies_path
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq new_admin_technology_path
  end

  scenario 'Page root path should have list of pages' do
    expect(page).to have_content 'Technology group title'
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
  end

  scenario 'Page root path should have our page name' do
    expect(page).to have_content 'TestTitle'
  end

  scenario 'Page root path links show, edit should work' do
    page.all(:link,'Show')[0].click
    expect(current_path).to eq admin_technology_path(Technology.last.id)
    visit admin_technologies_path
    page.all(:link,'Edit')[0].click
    expect(current_path).to eq edit_admin_technology_path(Technology.last.id)
  end

  scenario 'Link delete should delete page' do
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

  scenario 'Create technology should create technology with link' do
    click_link ('New')
    fill_in 'technology[title]', with: 'TestTitleFull'
    fill_in 'technology[link]', with: 'https://example.com/tech'
    fill_in 'technology[description]', with: 'PewPewPew'
    click_button 'Save'
    visit admin_technologies_path
    expect(page).to have_content 'TestTitleFull'
  end

  scenario 'Technology group must displays in index' do
    expect(page).to have_content technology_group.title
  end

  scenario 'Validation for new technology' do
    click_link('New')
    find('#technology_technology_group_id').find(:xpath, 'option[1]').select_option
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end
