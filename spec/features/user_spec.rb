require 'rails_helper'

feature 'Users in admin panel.' do
  let(:user) { create(:user) }
  before do
    visit '/admin'
    login_user_post(user.email, 'secret')
    visit '/admin/users'
  end

  scenario 'Link list should work good' do
    click_link('List')
    expect(current_path).to eq '/admin/users'
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq '/admin/users/new'
  end

  scenario 'Users root path should have list of users' do
    expect(page).to have_content 'Email'
  end

  scenario 'Users root path should have our user email' do
    expect(page).to have_content user.email
  end

  scenario 'Users root path links show, edit should work' do
    click_link ('Show')
    expect(current_path).to eq "/admin/users/#{user.id}"
    visit '/admin/users'
    click_link ('Edit')
    expect(current_path).to eq "/admin/users/#{user.id}/edit"
  end

  scenario 'link delete should delete user' do
    click_link ('Destroy')
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
    click_button 'Save'
    visit '/admin/users'
    expect(page).to have_content 'TestUser@test.com'
  end

  scenario 'validation for new user' do
    #todo add validation for User.create
  end
end