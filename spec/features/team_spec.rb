require 'rails_helper'

feature 'Adding team to site.' do

  before do
    @member = FactoryGirl.create(:member)
    visit "/team"
  end

  scenario 'Should created profile in list of profiles' do
    expect(page).to have_content @member.name
  end

  scenario 'Should have link to profile' do
    click_link("Watch Profile")
    expect(page).to have_content "About"
  end
end