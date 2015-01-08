require 'rails_helper'

feature 'Access the admin panel' do
  given(:user) { create(:user, password: 'correct_password') }

  scenario 'forbid access to dashboard without fill the correct login/password' do
    visit '/admin'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'wrong_password'
    click_button 'Log in'
    visit '/admin'
    expect(current_path).to eq login_path
  end

  scenario 'displays dashboard after correct login' do
    visit '/admin'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'correct_password'
    click_button 'Log in'
    visit '/admin'
    expect(current_path).to eq '/admin'
    within 'h1' do
      expect(page).to have_content 'Webgate Systems'
    end
    expect(page).to have_content 'Users'
    expect(page).to have_content 'Pages'
  end

end
