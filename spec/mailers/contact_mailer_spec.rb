require 'rails_helper'

describe ContactMailer, type: :mailer do
  let(:contact) { build(:contact) }
  let(:bot) { build(:bot) }

  it 'has a valid factory' do
    expect(build(:contact)).to be_valid
  end

  describe '#contact mail' do
    it 'mail from contacts' do
      last_email = ContactMailer.contact_mail(contact)
      expect(last_email).to have_content(contact.content)
      expect(last_email.subject).to_not include 'SPAM'
    end
    it 'mail from bots - SPAM' do
      last_email = ContactMailer.contact_mail(bot)
      expect(last_email.subject).to include 'SPAM'
    end
  end
end
