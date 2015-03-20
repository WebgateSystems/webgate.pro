def sign_in(user)
  visit '/admin'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: 'secret'
  click_button 'Log in'
end
