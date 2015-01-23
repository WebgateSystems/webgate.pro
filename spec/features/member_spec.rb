require 'rails_helper'

feature 'Adding member to admin panel.' do
  given (:member) {create (:member)}
  given(:user) { create(:user, password: 'correct_password') }

  before do
    visit '/admin'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'correct_password'
    click_button 'Log in'
    visit '/admin/members/new'
    fill_in 'member[name]', with: member.name
    fill_in 'member[shortdesc]', with: member.shortdesc
    fill_in 'member[description]', with: member.description
    fill_in 'member[motto]', with: member.motto
    click_button 'Save'
  end

  scenario 'Success create new member' do
    visit '/admin/members'
    expect(page).to have_content member.name
  end

  scenario 'Displays all attributes' do
    visit '/admin/members'
    page.all(:link,member.name)[0].click
    expect(page).to have_content member.name
    expect(page).to have_content member.shortdesc
    expect(page).to have_content member.description
    expect(page).to have_content member.motto
  end

end