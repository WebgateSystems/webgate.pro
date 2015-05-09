class SupportMailer < ActionMailer::Base
  include Sidekiq::Worker

  default to: 'biuro@webgate.pro'

  def contact_support(contact)
    if contact.nickname.present?
      mail from: contact.email, subject: 'SPAM', body: contact.content
    else
      mail from: contact.email, subject: t('contact_form'), body: contact.content
    end
  end
end
