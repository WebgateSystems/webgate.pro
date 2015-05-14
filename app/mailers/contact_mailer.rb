class ContactMailer < ActionMailer::Base
  include Sidekiq::Worker
  sidekiq_options queue: :mail

  default to: APP_CONFIG['office_email']

  def contact_mail(contact)
    @contact = contact
    subject = t('contact_form')
    if contact.nickname.present?
      subject = 'SPAM'
    end
    mail from: '"Notifier" <notifier@webgate.pro>', reply_to: %("#{@contact.name}" <#{contact.email}>), subject: subject
  end
end
