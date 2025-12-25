# frozen_string_literal: true

module OnTheFlyTranslation
  THREAD_KEY_ENABLED = :__otf_translation_enabled
  THREAD_KEY_SILENCED = :__otf_translation_silenced

  module_function

  def enabled?
    Thread.current[THREAD_KEY_ENABLED] == true && GptSettings.enabled?
  end

  def enable!
    Thread.current[THREAD_KEY_ENABLED] = true
  end

  def disable!
    Thread.current[THREAD_KEY_ENABLED] = false
  end

  def silenced?
    Thread.current[THREAD_KEY_SILENCED] == true
  end

  def silence!
    Thread.current[THREAD_KEY_SILENCED] = true
  end

  def unsilence!
    Thread.current[THREAD_KEY_SILENCED] = false
  end

  def with_enabled
    prev = enabled?
    enable!
    yield
  ensure
    Thread.current[THREAD_KEY_ENABLED] = prev
  end

  def with_silenced
    prev = silenced?
    silence!
    yield
  ensure
    Thread.current[THREAD_KEY_SILENCED] = prev
  end
end
