require 'exception_notification/rails'
#require 'exception_notification/sidekiq'

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |exception, options|
    Rails.env.development? or Rails.env.test?
  end

  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  config.add_notifier :email, {
    email_prefix: Rails.env.production? ? '[webgate.pro - exception]' : '[test.webgate.pro - exception]',
    sender_address: %{"webgate.pro exception notifier" <notify@webgate.pro>},
    exception_recipients: %w{yunixon@gmail.com}, #%w{devs@webgate.pro}
    delivery_method: :smtp,
    smtp_settings: {
      tls: ENV['tls'],
      address: ENV['address'],
      port: ENV['port'],
      domain: ENV['domain'],
      user_name: ENV['user_name'],
      password: ENV['password'],
      authentication: ENV['authentication']
    }
  }
  #WebgatePro::Application.config.middleware.use ExceptionNotification::Rack,
  #  :email => {
  #    email_prefix: "[webgate.pro - exception] ",
  #    sender_address: %{"webgate.pro exception notifier" <notify@webgate.pro>},
  #    exception_recipients: %w{devs@webgate.pro},
  #    delivery_method: :smtp,
  #    smtp_settings: YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]['notify_smtp_data']
  #  }

  # Campfire notifier sends notifications to your Campfire room. Requires 'tinder' gem.
  # config.add_notifier :campfire, {
  #   :subdomain => 'my_subdomain',
  #   :token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # HipChat notifier sends notifications to your HipChat room. Requires 'hipchat' gem.
  # config.add_notifier :hipchat, {
  #   :api_token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # Webhook notifier sends notifications over HTTP protocol. Requires 'httparty' gem.
  # config.add_notifier :webhook, {
  #   :url => 'http://example.com:5555/hubot/path',
  #   :http_method => :post
  # }

end
