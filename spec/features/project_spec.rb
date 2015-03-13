require 'rails_helper'

feature 'Project in admin panel.' do

  let(:user) { create(:user) }

  before do
    sign_in(user)
    visit '/admin/projects'
    3.times do |t|
      click_link ('New')
      fill_in 'project[title]', with: "TestTitle#{t}"
      fill_in 'project[shortlink]', with: "Testlink#{t}"
      fill_in 'project[description]', with: "TestDesc#{t}"
      fill_in 'project[keywords]', with: "TestKeyWord#{t}"
      fill_in 'project[content]', with: "TestContent#{t}"
      fill_in 'project[livelink]', with: 'http://test.webgate.pro'
      click_button 'Save'
      visit '/admin/projects'
    end
  end

  scenario 'Project root path should have list of projects' do
    visit '/admin/projects'
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'Publish'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'TestTitle1'
    expect(page).to have_content 'TestTitle2'
  end

  scenario 'Try drag and drop on index', js: true do
    visit '/admin/projects'
    dest_element = find('td', text: "TestTitle2")
    source_element = find('td', text: "TestTitle1")
    source_element.drag_to dest_element
    sleep 5 #wait for ajax complete
    page.all(:link, 'Show')[1].click
    expect(current_path).to eq "/admin/projects/#{Project.last.id}"
    visit '/admin/projects'
    page.all(:link, 'Show')[2].click
    expect(current_path).to_not eq "/admin/projects/#{Project.last.id}"
  end

  scenario 'Link list should work good' do
    click_link('List')
    expect(current_path).to eq '/admin/projects'
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq '/admin/projects/new'
  end

  scenario 'Project root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(current_path).to eq "/admin/projects/#{Project.first.id}"
    visit '/admin/projects'
    page.all(:link, 'Edit')[0].click
    expect(current_path).to eq "/admin/projects/#{Project.first.id}/edit"
  end

  scenario 'Link delete should delete project' do
    page.all(:link, 'Delete')[0].click
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our project information' do
    click_link ('TestTitle0')
    expect(page).to have_content 'Title:'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'Description:'
    expect(page).to have_content 'TestDesc0'
    expect(page).to have_content 'Shortlink:'
    expect(page).to have_content 'Keywords:'
    expect(page).to have_content 'Content:'
    expect(page).to have_content 'Testlink0'
    expect(page).to have_content 'TestKeyWord0'
    expect(page).to have_content 'TestContent0'
    expect(page).to have_content 'http://test.webgate.pro'
  end

  scenario 'Create project should create project' do
    click_link ('New')
    fill_in 'project[title]', with: 'TestTitleFull'
    fill_in 'project[shortlink]', with: 'TestlinkFull'
    fill_in 'project[description]', with: 'TestDescFull'
    fill_in 'project[keywords]', with: 'TestKeyWordFull'
    fill_in 'project[content]', with: 'TestContentFull'
    fill_in 'project[livelink]', with: 'http://test.webgate.pro'
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
    fill_in 'project[shortlink]', with: 'TestlinkFull'
    fill_in 'project[description]', with: 'TestDescFull'
    fill_in 'project[keywords]', with: 'TestKeyWordFull'
    fill_in 'project[content]', with: 'TestContentFull'
    fill_in 'project[livelink]', with: 'http://test.webgate.pro'
    find(:css, "#project_publish").set(true)
    click_button 'Save'
    visit '/admin/projects'
    expect(page).to have_content 'true'
  end

  scenario 'Validation for new project' do
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
