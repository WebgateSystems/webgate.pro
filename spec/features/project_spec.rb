require 'rails_helper'

feature 'Project in admin panel.' do
  let(:user) { create(:user) }
  before do
    visit '/admin'
    login_user_post(user.email, 'secret')
    visit '/admin/projects'
    click_link ('New')
    fill_in 'project[title]', with: 'TestTitle'
    fill_in 'project[shortlink]', with: 'Testlink'
    fill_in 'project[description]', with: 'TestDesc'
    fill_in 'project[keywords]', with: 'TestKeyWord'
    fill_in 'project[content]', with: 'TestContent'
    click_button 'Save'
    visit '/admin/projects'
  end


  scenario 'Link list should work good' do
    click_link('List')
    expect(current_path).to eq '/admin/projects'
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq '/admin/projects/new'
  end

  scenario 'project root path should have list of projects' do
    expect(page).to have_content 'ID'
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'Publish'
  end

  scenario 'project root path should have our project name' do
    expect(page).to have_content 'TestTitle'
  end

  scenario 'project root path links show, edit should work' do
    page.all(:link,'Show')[0].click
    expect(current_path).to eq "/admin/projects/#{Project.last.id}"
    visit '/admin/projects'
    page.all(:link,'Edit')[0].click
    expect(current_path).to eq "/admin/projects/#{Project.last.id}/edit"
  end

  scenario 'link delete should delete project' do
    page.all(:link,'Delete')[0].click
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our project information' do
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

  scenario 'Create project should create project' do
    click_link ('New')
    fill_in 'project[title]', with: 'TestTitleFull'
    fill_in 'project[shortlink]', with: 'Testlink1'
    fill_in 'project[description]', with: 'TestDesc1'
    fill_in 'project[keywords]', with: 'TestKeyWord1'
    fill_in 'project[content]', with: 'TestContent1'
    click_button 'Save'
    visit '/admin/projects'
    expect(page).to have_content 'TestTitleFull'
  end

  scenario 'Check publish. Here should be false' do
    expect(page).to have_content 'false'
  end

  scenario 'Check publish. Here should be true' do
    click_link ('New')
    fill_in 'project[title]', with: 'TestTitleFull'
    fill_in 'project[shortlink]', with: 'Testlink1'
    fill_in 'project[description]', with: 'TestDesc1'
    fill_in 'project[keywords]', with: 'TestKeyWord1'
    fill_in 'project[content]', with: 'TestContent1'
    find(:css, "#project_publish").set(true)
    click_button 'Save'
    visit '/admin/projects'
    expect(page).to have_content 'true'
  end
  scenario 'validation for new project' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  scenario 'Dont create project with empty fields' do
    click_link ('New')
    fill_in 'project[title]', with: 'TestTitlekukumba'
    visit '/admin/projects'
    expect(page).to have_no_content 'TestTitlekukumba'
  end
end