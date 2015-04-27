require "rails_helper"

describe SupportMailer, type: :mailer do

  let(:contact) { build(:contact) }
  let(:bot) { build(:bot) }

  it 'has a valid factory' do
    expect(build(:contact)).to be_valid
  end

  describe '#contact support' do
    it 'renders the sender contact email' do
      last_email = SupportMailer.contact_support(contact)
      expect(last_email.from).to include contact.email
      expect(last_email).to have_content(contact.content)
      expect(last_email.subject).to_not include 'SPAM'
    end
    it 'bot contact to SPAM' do
      last_email = SupportMailer.contact_support(bot)
      expect(last_email.subject).to include 'SPAM'
    end
  end

end
