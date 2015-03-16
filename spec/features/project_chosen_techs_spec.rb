require 'rails_helper'

feature 'Project in admin panel.' do

  let(:user) { create(:user) }
  let(:technology) { create(:technology) }

  before do
    sign_in(user)
    visit '/admin/projects'
    click_link ('New')
    fill_in 'project[title]', with: "TestTitle0"
    fill_in 'project[shortlink]', with: "Testlink0"
    fill_in 'project[description]', with: "TestDesc0"
    fill_in 'project[keywords]', with: "TestKeyWord0"
    fill_in 'project[content]', with: "TestContent0"
    fill_in 'project[livelink]', with: 'http://test.webgate.pro'
    select_from_chosen(technology.title, from: 'project_technology_ids')
    click_button 'Save'
  end

  scenario 'Project should with assigned technology', js: true do
    visit '/admin/projects'
    click_link ('New')
    fill_in 'project[title]', with: 'TestTitleFull'
    fill_in 'project[shortlink]', with: 'TestlinkFull'
    fill_in 'project[description]', with: 'TestDescFull'
    fill_in 'project[keywords]', with: 'TestKeyWordFull'
    fill_in 'project[content]', with: 'TestContentFull'
    fill_in 'project[livelink]', with: 'http://test.webgate.pro'
    select_from_chosen(technology.title, from: 'project_technology_ids')
    click_button 'Save'
    visit '/admin/projects'
    click_link ('TestTitleFull')
    expect(page).to have_content technology.title
  end
end
