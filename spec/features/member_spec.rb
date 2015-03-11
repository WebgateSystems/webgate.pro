require 'rails_helper'

feature 'Member in admin panel.' do
  let(:user) { create(:user) }
  before do
    visit '/admin'
    login_user_post(user.email, 'secret')
    visit '/admin/members'
    click_link ('New')
    fill_in 'member[name]', with: 'TestName'
    fill_in 'member[shortdesc]', with: 'TestShortDesc'
    fill_in 'member[description]', with: 'TestDesc'
    fill_in 'member[motto]', with: 'TestMotto'
    click_button 'Save'
    visit '/admin/members'
  end


  scenario 'Link list should work good' do
    click_link('List')
    expect(current_path).to eq '/admin/members'
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq '/admin/members/new'
  end

  scenario 'member root path should have list of members' do
    expect(page).to have_content 'ID'
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Created at'
  end

  scenario 'member root path should have our member name' do
    expect(page).to have_content 'TestName'
  end

  scenario 'member root path links show, edit should work' do
    page.all(:link,'Show')[0].click
    expect(current_path).to eq "/admin/members/#{Member.last.id}"
    visit '/admin/members'
    page.all(:link,'Edit')[0].click
    expect(current_path).to eq "/admin/members/#{Member.last.id}/edit"
  end

  scenario 'link delete should delete member' do
    page.all(:link,'Delete')[0].click
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our member information' do
    click_link ('TestName')
    expect(page).to have_content 'Name:'
    expect(page).to have_content 'TestName'
    expect(page).to have_content 'Description:'
    expect(page).to have_content 'TestDesc'
    expect(page).to have_content 'Short description:'
    expect(page).to have_content 'Motto:'
    expect(page).to have_content 'TestShortDesc'
    expect(page).to have_content 'TestMotto'
  end

  scenario 'Create member should create member' do
    click_link ('New')
    fill_in 'member[name]', with: 'TestNamePew'
    fill_in 'member[shortdesc]', with: 'TestShortDescPew'
    fill_in 'member[description]', with: 'TestDescPew'
    fill_in 'member[motto]', with: 'TestMottoPew'
    click_button 'Save'
    visit '/admin/members'
    expect(page).to have_content 'TestNamePew'
  end

  scenario 'validation for new member' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  scenario 'Dont create member with empty fields' do
    click_link ('New')
    fill_in 'member[name]', with: 'Testname'
    visit '/admin/members'
    expect(page).to have_no_content 'Testname'
  end
end
