describe 'Adding projects to portfolio.' do
  let!(:project1) do
    I18n.with_locale(:en) do
      Project.create(
        title: 'TestTitle0', content: 'TestContent0', livelink: 'http://test.webgate.pro',
        publish: true,
        collage: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/body.jpg').to_s)
      )
    end
  end
  let!(:project2) do
    I18n.with_locale(:en) do
      Project.create(title: 'TestTitle1', content: 'TestContent1', livelink: 'http://test.webgate.pro',
                     publish: true, collage: nil)
    end
  end

  before do
    I18n.locale = :en
    visit portfolio_path
  end

  it 'is shows projects with collage' do
    expect(page).to have_xpath("//img[contains(@src, \"/spec/uploads/project/#{project1.id}\")]")
  end

  it 'is shows project title' do
    expect(page).to have_content project1.title
  end

  it 'is shows project content' do
    expect(page).to have_content project1.content
  end

  it 'does not show projects without collage' do
    expect(page).not_to have_content project2.title
  end
end
