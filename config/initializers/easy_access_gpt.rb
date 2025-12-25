# Ensure availability during boot (initializer runs very early in some environments)
require_dependency Rails.root.join('app/services/gpt_settings').to_s

EasyAccessGpt::Configure.api_key = GptSettings.key
EasyAccessGpt::Configure.available_locales = I18n.available_locales
