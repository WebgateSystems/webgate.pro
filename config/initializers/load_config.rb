APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
# ActionMailer::Base.smtp_settings = {
#   :enable_starttls_auto => APP_CONFIG['am_smtp_data']['tls'],
#   :address            => APP_CONFIG['am_smtp_data']['address'],
#   :port               => APP_CONFIG['am_smtp_data']['port'],
#   :domain             => APP_CONFIG['am_smtp_data']['domain'],
#   :authentication     => APP_CONFIG['am_smtp_data']['authentication'],
#   :user_name          => APP_CONFIG['am_smtp_data']['user_name'],
#   :password           => APP_CONFIG['am_smtp_data']['password']
# }
