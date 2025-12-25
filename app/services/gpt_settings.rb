# frozen_string_literal: true

module GptSettings
  module_function

  def enabled?
    enabled = if Settings.respond_to?(:services) &&
                 Settings.services.respond_to?(:gpt) &&
                 Settings.services.gpt.respond_to?(:enabled)
                Settings.services.gpt.enabled
              end

    return enabled unless enabled.nil?

    false
  end

  def key
    key = if Settings.respond_to?(:services) &&
             Settings.services.respond_to?(:gpt) &&
             Settings.services.gpt.respond_to?(:key)
            Settings.services.gpt.key
          end

    return key if key.present?

    Settings.respond_to?(:gpt_key) ? Settings.gpt_key : nil
  end
end
