class LinkErrorMailer < ActionMailer::Base
  include Sidekiq::Worker
  sidekiq_options queue: :mail

  default to: APP_CONFIG['devs_email']

  def link_error_mail(link)
    subject = t(:error_404)

    mail from: '"Notifier" <notifier@webgate.pro>', subject: subject, body: link
  end
end
