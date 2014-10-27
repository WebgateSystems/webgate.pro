require 'spec_helper'

describe "access the admin panel" do
  before { @user = create(:user, password: "correct_password" )}
  it "forbid access to dashboard without fill the correct login/password" do
    visit admin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'wrong_password'
    click_button 'Log in'
    visit admin_path
    current_path.should eq login_path
  end
  it "displays dashboard after correct login" do
    visit admin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'correct_password'
    click_button 'Log in'
    visit admin_path
    current_path.should eq admin_path
    within 'h1' do
      page.should have_content 'Webgate Systems'
    end
    page.should have_content 'Users'
    page.should have_content 'Pages'
  end
end
