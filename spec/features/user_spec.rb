require 'rails_helper'

feature 'Users in admin panel.' do
  let(:user) { create(:user) }
  before do
    visit admin_root_path
    login_user_post(user.email, 'secret')
    visit admin_users_path
  end

  scenario 'Link list should work good' do
    visit new_admin_user_path
    click_link('List')
    expect(current_path).to eq admin_users_path
  end

  scenario 'Users root path should have list of users' do
    expect(page).to have_content 'Email'
  end

  scenario 'Users root path should have our user email' do
    expect(page).to have_content user.email
  end

  scenario 'Users root path links show, edit should work' do
    click_link ('Show')
    expect(current_path).to eq admin_user_path(user.id)
    visit admin_users_path
    click_link ('Edit')
    expect(current_path).to eq edit_admin_user_path(user.id)
  end

  scenario 'link delete should delete user' do
    click_link ('Delete')
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our email' do
    click_link ('Show')
    expect(page).to have_content 'Email:'
    expect(page).to have_content user.email
  end

  scenario 'Create user should create user' do
    click_link ('New')
    fill_in 'user[email]', with: 'TestUser@test.com'
    fill_in 'user[password]', with: 'password123'
    fill_in 'user[password_confirmation]', with: 'password123'
    click_button 'Save'
    visit admin_users_path
    expect(page).to have_content 'TestUser@test.com'
  end

  scenario 'validation for new user(no password)' do
    click_link ('New')
    fill_in 'user[email]', with: 'TestUser@test.com'
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  scenario 'validation for new user(password and password confirmation mismatch)' do
    click_link ('New')
    fill_in 'user[email]', with: 'TestUser@test.com'
    fill_in 'user[password]', with: 'password123'
    fill_in 'user[password_confirmation]', with: 'bla1234'
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  scenario 'validation for new user(no email)' do
    click_link ('New')
    fill_in 'user[password]', with: 'TestUser@test.com'
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  scenario 'validation for new user(empty field)' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  scenario 'validation for new user. Email should be correct' do
    click_link ('New')
    fill_in 'user[email]', with: 'wery wronk@@@emaiL.com.com.e'
    fill_in 'user[password]', with: 'bad'
    click_button 'Save'
    visit admin_users_path
    expect(page).to have_no_content 'wery wronk@@@emaiL.com.com.e'
  end
end
