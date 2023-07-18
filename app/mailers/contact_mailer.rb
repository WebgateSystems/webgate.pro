class ContactMailer < ApplicationMailer
  include Sidekiq::Worker
  sidekiq_options queue: :mail

  default to: APP_CONFIG['office_email']

  def contact_mail(name:, email:, nickname:, content:)
    @contact = { name:, email:, nickname:, content: }
    subject = nickname.present? ? 'SPAM' : t(:contact_form)
    mail from: '"Notifier" <notifier@webgate.pro>', reply_to: %("#{name}" <#{email}>), subject:
  end
end
