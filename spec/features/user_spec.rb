require 'rails_helper'

describe 'Users in admin panel.' do
  let(:user) { create(:user) }

  before do
    visit admin_root_path
    login_user_post(user.email, 'secret')
    visit admin_users_path
  end

  it 'Link list should work good' do
    visit new_admin_user_path
    click_link('List')
    expect(page).to have_current_path admin_users_path, ignore_query: true
  end

  it 'Users root path should have list of users' do
    expect(page).to have_content 'Email'
  end

  it 'Users root path should have our user email' do
    expect(page).to have_content user.email
  end

  it 'Users root path links show, edit should work' do
    click_link('Show')
    expect(page).to have_current_path admin_user_path(user.id), ignore_query: true
    visit admin_users_path
    click_link('Edit')
    expect(page).to have_current_path edit_admin_user_path(user.id), ignore_query: true
  end

  it 'link delete should delete user' do
    click_link('Delete')
    expect(page).to have_current_path current_path, ignore_query: true
  end

  it 'Show should display our email' do
    click_link('Show')
    expect(page).to have_content 'Email:'
    expect(page).to have_content user.email
  end

  it 'Create user should create user' do
    click_link('New')
    fill_in 'user[email]', with: 'TestUser@test.com'
    fill_in 'user[password]', with: 'password123'
    fill_in 'user[password_confirmation]', with: 'password123'
    click_button 'Save'
    visit admin_users_path
    expect(page).to have_content 'TestUser@test.com'
  end

  it 'validation for new user(no password)' do
    click_link('New')
    fill_in 'user[email]', with: 'TestUser@test.com'
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  it 'validation for new user(password and password confirmation mismatch)' do
    click_link('New')
    fill_in 'user[email]', with: 'TestUser@test.com'
    fill_in 'user[password]', with: 'password123'
    fill_in 'user[password_confirmation]', with: 'bla1234'
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  it 'validation for new user(no email)' do
    click_link('New')
    fill_in 'user[password]', with: 'TestUser@test.com'
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  it 'validation for new user(empty field)' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  it 'validation for new user. Email should be correct' do
    click_link('New')
    fill_in 'user[email]', with: 'wery wronk@@@emaiL.com.com.e'
    fill_in 'user[password]', with: 'bad'
    click_button 'Save'
    visit admin_users_path
    expect(page).to have_no_content 'wery wronk@@@emaiL.com.com.e'
  end
end
