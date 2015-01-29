require 'rails_helper'

feature 'technology_group in admin panel.' do
  let(:user) { create(:user) }
  before do
    visit '/admin'
    login_user_post(user.email, 'secret')
    visit '/admin/technology_groups'
    click_link ('New')
    fill_in 'technology_group[title]', with: 'TestTitle'
    fill_in 'technology_group[description]', with: 'Test Description'
    click_button 'Save'
    visit '/admin/technology_groups'
  end

  scenario 'Link list should work good' do
    click_link('List')
    expect(current_path).to eq '/admin/technology_groups'
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq '/admin/technology_groups/new'
  end

  scenario 'technology_group root path should have list of technology_groups' do
    expect(page).to have_content 'ID'
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
  end

  scenario 'Users root path should have our technology_group title' do
    expect(page).to have_content 'TestTitle'
  end

  scenario 'Users root path links show, edit should work' do
    click_link ('Show')
    expect(current_path).to eq "/admin/technology_groups/#{TechnologyGroup.last.id}"
    visit '/admin/technology_groups'
    click_link ('Edit')
    expect(current_path).to eq "/admin/technology_groups/#{TechnologyGroup.last.id}/edit"
  end

  scenario 'link delete should delete technology_group' do
    click_link ('Delete')
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our technology_group info' do
    click_link ('Show')
    expect(page).to have_content 'Title:'
    expect(page).to have_content 'TestTitle'
    expect(page).to have_content 'Description:'
    expect(page).to have_content 'Test Description'
  end

  scenario 'Create technology_group should create technology_groups' do
    click_link ('New')
    fill_in 'technology_group[title]', with: 'TestTitleBrandNew'
    fill_in 'technology_group[description]', with: 'PewPewPew'
    click_button 'Save'
    visit '/admin/technology_groups'
    expect(page).to have_content 'TestTitleBrandNew'
  end

  scenario 'validation for new technology_group' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end