class SupportMailer < ActionMailer::Base
  include Sidekiq::Worker
  sidekiq_options queue: :mail

  default to: 'yuri.skurikhin@gmail.com'

  def contact_support(contact)
    @contact = contact
    subject = t('contact_form')
    if contact.nickname.present?
      subject = 'SPAM'
    end
    mail from: contact.email, reply_to: contact.email, subject: subject
  end
end
