require 'rails_helper'

feature 'Project in admin panel.' do

  let(:user) { create(:user) }
  let(:technology) { create(:technology) }

  before do
    sign_in(user)
    visit '/admin/members'
    click_link ('New')
    fill_in 'member[name]', with: 'TestName0'
    fill_in 'member[shortdesc]', with: 'TestShortDesc0'
    fill_in 'member[description]', with: 'TestDesc0'
    fill_in 'member[motto]', with: 'TestMotto0'
    select_from_chosen(technology.title, from: 'member_technology_ids')
    click_button 'Save'
  end

  scenario 'Member should with assigned technology', js: true do
    click_link ('New')
    fill_in 'member[name]', with: 'TestNamePew'
    fill_in 'member[shortdesc]', with: 'TestShortDescPew'
    fill_in 'member[description]', with: 'TestDescPew'
    fill_in 'member[motto]', with: 'TestMottoPew'
    select_from_chosen(technology.title, from: 'member_technology_ids')
    click_button 'Save'
    visit '/admin/members'
    click_link ('TestNamePew')
    expect(page).to have_content technology.title
  end
end
