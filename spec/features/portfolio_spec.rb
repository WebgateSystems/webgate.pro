require 'rails_helper'

feature 'Adding projects to portfolio.' do
  let!(:project1) { Project.create(title: 'TestTitle0', content: 'TestContent0', livelink: 'http://test.webgate.pro',
                                   publish: true, collage: Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'body.jpg'))) }
  let!(:project2) { Project.create(title: 'TestTitle1', content: 'TestContent1', livelink: 'http://test.webgate.pro',
                                   publish: true, collage: nil) }

  before do
    visit portfolio_path
  end

  scenario 'Should show projects with collage' do
    expect(page).to have_content project1.title
    expect(page).to have_content project1.content
    expect(page).to have_xpath("//img[contains(@src, \"/spec/uploads/project/#{project1.id}\")]")
  end

  scenario 'Should not show projects without collage', js: true do
    expect(page).to_not have_content project2.title
  end
end
