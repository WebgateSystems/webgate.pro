class ContactMailer < ApplicationMailer
  include Sidekiq::Worker
  sidekiq_options queue: :mail

  default to: APP_CONFIG['office_email']

  def contact_mail(email, name, nickname)
    subject = nickname.present? ? 'SPAM' : t(:contact_form)
    mail from: '"Notifier" <notifier@webgate.pro>', reply_to: %("#{name}" <#{email}>), subject:
  end
end
