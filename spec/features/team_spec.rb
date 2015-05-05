require 'rails_helper'

feature 'Adding team to site.' do

  let!(:member1) { Member.create(name: 'TestName1', job_title: 'TestJobTitle1',
      description: 'TestDesc1', motto: 'TestMotto1', publish: true,
      avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'yuri_skurikhin.png'))) }

  let!(:member2) { Member.create(name: 'TestName2', job_title: 'TestJobTitle2',
      description: 'TestDesc2', motto: 'TestMotto1', publish: true,
      avatar: nil) }

  before do
    visit "/team"
  end

  scenario 'Should show list of team members' do
    expect(page).to have_content member1.name
    expect(page).to have_content member1.job_title
    expect(page).to have_xpath("//img[contains(@src, \"/spec/uploads/member/#{member1.id}\")]")
  end

  scenario 'Should not show member without avatar' , js: true do
    expect(page).to_not have_content member2.name
  end

  scenario 'Show and Hide extend team members information', js: true do
    page.execute_script("$('span.team_name').click()")
    expect(page).to have_content 'Basic information'
    expect(page).to have_content member1.description
    page.execute_script("$('span.mob.service_block_btn').click()")
    expect(page).to_not have_content 'Technologies'
  end

end
