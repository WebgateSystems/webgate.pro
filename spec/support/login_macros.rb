def sign_in(user)
  visit '/admin'
  fill_in 'email', with: user.email
  fill_in 'password', with: 'secret'
  click_button 'Log in'
end
