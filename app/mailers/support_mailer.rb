class SupportMailer < ActionMailer::Base
  include Sidekiq::Worker
  sidekiq_options queue: :mail

  default to: 'biuro@webgate.pro'

  def contact_support(contact)
    @contact = contact
    subject = t('contact_form')
    if contact.nickname.present?
      subject = 'SPAM'
    end
    mail from: '"Notifier" <notifier@webgate.pro>', reply_to: %("#{@contact.name}" <#{contact.email}>), subject: subject
  end
end
