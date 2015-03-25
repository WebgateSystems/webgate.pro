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

  scenario 'List page should have avatar' do
    expect(page).to have_xpath("//img[contains(@src, \"uploads/pictures/member\")]")
  end

end
