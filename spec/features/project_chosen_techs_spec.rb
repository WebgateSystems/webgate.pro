require 'rails_helper'

feature 'Project in admin panel.' do

  let(:user) { create(:user) }
  let!(:technology) { create(:technology) }

  before do
    sign_in(user)
    visit '/admin/projects'
  end

  scenario 'Project should with assigned technology', js: true do
    visit '/admin/projects'
    click_link ('New')
    fill_in 'project[title]', with: 'TestTitleFull'
    fill_in 'project[content]', with: 'TestContentFull'
    fill_in 'project[livelink]', with: 'http://test.webgate.pro'
    attach_file('project[collage]', File.join(Rails.root, '/spec/fixtures/projects/tested.jpg'))
    select technology.title, from: 'project_technology_ids', visible: false
    click_button 'Save'
    visit '/admin/projects'
    click_link ('TestTitleFull')
    expect(page).to have_content technology.title
  end
end
