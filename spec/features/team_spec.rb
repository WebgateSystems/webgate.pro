require 'rails_helper'

feature 'Adding team to site.' do

  let!(:member1) { Member.create(name: 'TestName1', shortdesc: 'TestShortDesc1',
      description: 'TestDesc1', motto: 'TestMotto1',
      avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'alex_dobr.jpg'))) }

  before do
    visit "/team"
  end

  scenario 'Should show list of team members' do
    expect(page).to have_content member1.name
    expect(page).to have_content member1.shortdesc
    expect(page).to have_xpath("//img[contains(@src, \"uploads/pictures/member\")]")
  end

  scenario 'Show and Hide extend team members information', js: true do
    page.execute_script("$('span.team_name').click()")
    expect(page).to have_content 'Technologies'
    expect(page).to have_content 'About'
    expect(page).to have_content member1.description
    page.execute_script("$('span.mob.service_block_btn').click()")
    expect(page).to_not have_content 'Technologies'
  end

end
