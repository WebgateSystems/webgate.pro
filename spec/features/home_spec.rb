require 'rails_helper'

describe 'Home page' do
  before do
    visit '/'
    reset_email
  end

  after do
    ActionMailer::Base.deliveries.clear
    Sidekiq::Worker.clear_all
  end

  # scenario 'Contact form should mail' do
  #   fill_in 'contact[name]', with: 'TestName'
  #   fill_in 'contact[email]', with: 'test@example.com'
  #   fill_in 'contact[content]', with: 'TestContent'
  #   click_button 'Send'

  #   expect(ActionMailer::Base.deliveries.count).to eq(1)
  #   expect(last_email).to have_content('TestContent')
  # end

  it 'Contact form should not mail' do
    fill_in 'contact[name]', with: 'TestName'
    fill_in 'contact[email]', with: 'bad_mail'
    fill_in 'contact[content]', with: 'TestContent'
    click_button 'Send'

    expect(ActionMailer::Base.deliveries.count).not_to eq(1)
    expect(last_email).not_to have_content('TestContent')
  end
end
