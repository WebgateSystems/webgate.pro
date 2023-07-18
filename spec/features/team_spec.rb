describe 'Adding team to site.', type: :feature do
  let!(:member1) do
    Member.create(name: 'TestName1', job_title: 'TestJobTitle1',
                  description: 'TestDesc1', education: 'TestEduc1', motto: 'TestMotto1', publish: true,
                  avatar: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/yuri_skurikhin.png').to_s))
  end

  let!(:member2) do
    Member.create(name: 'TestName2', job_title: 'TestJobTitle2',
                  description: 'TestDesc2', education: 'TestEduc2', motto: 'TestMotto1', publish: true,
                  avatar: nil)
  end

  before do
    visit team_path
  end

  it 'shows list of team members' do
    expect(page).to have_content member1.name
    expect(page).to have_content member1.job_title
    expect(page).to have_xpath("//img[contains(@src, \"/spec/uploads/member/#{member1.id}\")]")
  end

  it 'does not show member without avatar' do
    expect(page).not_to have_content member2.name
  end

  # it 'Show and Hide extend team members information' do
  #   page.find('.team_name').click
  #   expect(page).to have_content 'Basic information'
  #   expect(page).to have_content member1.description
  #   page.find('.mob.service_block_btn').click
  #   expect(page).not_to have_content 'Technologies'
  # end
end
