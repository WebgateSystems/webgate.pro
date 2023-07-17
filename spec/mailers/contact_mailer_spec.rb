# require 'rails_helper'

# describe ContactMailer, type: :mailer do
#   let(:contact) { build(:contact) }
#   let(:bot) { build(:bot) }

#   it 'has a valid factory' do
#     expect(build(:contact)).to be_valid
#   end

#   describe '#contact mail' do
#     it 'mail from contacts' do
#       binding.pry

#       last_email = described_class.contact_mail(contact.email, contact.name, contact.nickname)
#       expect(last_email).to have_content(contact.content)
#       expect(last_email.subject).not_to include 'SPAM'
#     end

#     it 'mail from bots - SPAM' do
#       last_email = described_class.contact_mail(bot)
#       expect(last_email.subject).to include 'SPAM'
#     end
#   end
# end
