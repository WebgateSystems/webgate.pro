require 'rails_helper'

feature 'Adding team to site.' do

  before do
    @member = FactoryGirl.create(:member)
    visit "/team"
  end

  scenario 'Should created profile in list of profiles' do
    expect(page).to have_content @member.name
    expect(page).to have_content @member.shortdesc
  end

  scenario 'Should have link to profile' do
    click_link("Watch Profile")
    expect(current_path).to eq "/team/#{@member.id}"
  end

  scenario 'About page should have all information' do
    visit "/team/#{@member.id}"
    expect(page).to have_content @member.name
    expect(page).to have_content @member.motto
    expect(page).to have_content @member.description
  end

  scenario 'About page should have avatar' do
    visit "/team/#{@member.id}"
    expect(page).to have_xpath("//img[@src=\"#{Rails.root}/spec/support/uploads/thumb.jpg\"]")
  end

  scenario 'List page should have avatar' do
    expect(page).to have_xpath("//img[@src=\"#{Rails.root}/spec/support/uploads/thumb.jpg\"]")
  end

  scenario 'Show page should have link to /team' do
    visit "/team/#{@member.id}"
    click_link('Go Back')
    expect(current_path).to eq '/team'
  end

end