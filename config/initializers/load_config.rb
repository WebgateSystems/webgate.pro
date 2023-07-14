APP_CONFIG = YAML.load_file(Rails.root.join('config/config.yml').to_s)[Rails.env]

ActionMailer::Base.smtp_settings = {
  enable_starttls_auto: APP_CONFIG['smtp_data']['tls'],
  address: APP_CONFIG['smtp_data']['address'],
  port: APP_CONFIG['smtp_data']['port'],
  domain: APP_CONFIG['smtp_data']['domain'],
  authentication: APP_CONFIG['smtp_data']['authentication'],
  user_name: APP_CONFIG['smtp_data']['user_name'],
  password: APP_CONFIG['smtp_data']['password']
}
