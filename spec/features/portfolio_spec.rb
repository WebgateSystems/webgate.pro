describe 'Adding projects to portfolio.' do
  let!(:project1) do
    Project.create(title: 'TestTitle0', content: 'TestContent0', livelink: 'http://test.webgate.pro',
                   publish: true, collage: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/body.jpg').to_s))
  end
  let!(:project2) do
    Project.create(title: 'TestTitle1', content: 'TestContent1', livelink: 'http://test.webgate.pro',
                   publish: true, collage: nil)
  end

  before do
    visit portfolio_path
  end

  it 'shows projects with collage' do
    expect(page).to have_content project1.title
    expect(page).to have_content project1.content
    expect(page).to have_xpath("//img[contains(@src, \"/spec/uploads/project/#{project1.id}\")]")
  end

  it 'does not show projects without collage' do
    expect(page).not_to have_content project2.title
  end
end
