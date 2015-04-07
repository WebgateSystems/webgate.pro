require 'rails_helper'

feature 'Home page' do

  before do
    visit "/"
    SupportMailer.stub(:delay).and_return(SupportMailer)
  end

  scenario 'Contact form should mail' do
    fill_in 'contact[name]', with: "TestName"
    fill_in 'contact[email]', with: "test@test.com"
    fill_in 'contact[content]', with: "TestContent"
    click_button 'Send'
    #expect(SupportMailer).to receive(:contact_support).once
  end

  scenario 'Contact form should not mail' do

  end

end
