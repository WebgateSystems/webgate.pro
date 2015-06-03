class ContactMailer < ActionMailer::Base
  include Sidekiq::Worker
  sidekiq_options queue: :mail

  default to: APP_CONFIG['office_email']

  def contact_mail(contact)
    @contact = contact
    subject = contact.nickname.present? ? 'SPAM' : t('contact_form')
    mail from: '"Notifier" <notifier@webgate.pro>', reply_to: %("#{@contact.name}" <#{contact.email}>), subject: subject
  end
end
