# frozen_string_literal: true

Rails.application.config.to_prepare do
  # Globalize defines Translation classes dynamically; include our callbacks after load.
  [Project::Translation, Member::Translation, Technology::Translation].each do |klass|
    next if klass.included_modules.include?(OnTheFlyTranslationCallbacks)

    klass.include(OnTheFlyTranslationCallbacks)
  end
end
