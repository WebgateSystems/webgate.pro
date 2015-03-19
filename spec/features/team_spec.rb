require 'rails_helper'

feature 'Adding team to site.' do

  before do
    @member = create(:member)
    visit "/team"
  end

  scenario 'Should created profile in list of profiles' do
    expect(page).to have_content @member.name
    expect(page).to have_content @member.shortdesc
  end

  scenario 'About page should have all information' do
    visit "/team/#{@member.id}"
    expect(page).to have_content @member.name
    expect(page).to have_content @member.motto
    expect(page).to have_content @member.description
  end

  scenario 'About page should have avatar' do
    visit "/team/#{@member.id}"
    expect(page).to have_xpath("//img[contains(@src, #{@member.avatar.url})]")
  end

  scenario 'List page should have avatar' do
    expect(page).to have_xpath("//img[contains(@src, \"uploads/pictures/member\")]")
  end

  scenario 'Show page should have link to /team' do
    visit "/team/#{@member.id}"
    click_link('Back to Team')
    expect(current_path).to eq '/team'
  end

end
