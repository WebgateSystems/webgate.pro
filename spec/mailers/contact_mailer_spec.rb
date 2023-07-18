describe ContactMailer, type: :mailer do
  let(:contact) { attributes_for(:contact) }
  let(:bot) { attributes_for(:bot) }

  it 'has a valid factory' do
    expect(build(:contact)).to be_valid
  end

  describe '#contact mail' do
    it 'mail from contacts' do
      last_email = described_class.contact_mail(**contact)
      expect(last_email).to have_content(contact[:content])
      expect(last_email.subject).not_to include 'SPAM'
    end

    it 'mail from bots - SPAM' do
      last_email = described_class.contact_mail(**bot)
      expect(last_email.subject).to include 'SPAM'
    end
  end
end
