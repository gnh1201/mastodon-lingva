# frozen_string_literal: true
# for Mastodon 4.0.2

class TranslationService
  class Error < StandardError; end
  class NotConfiguredError < Error; end
  class TooManyRequestsError < Error; end
  class QuotaExceededError < Error; end
  class UnexpectedResponseError < Error; end

  def self.configured
    if ENV['DEEPL_API_KEY'].present?
      TranslationService::DeepL.new(ENV.fetch('DEEPL_PLAN', 'free'), ENV['DEEPL_API_KEY'])
    elsif ENV['LIBRE_TRANSLATE_ENDPOINT'].present?
      TranslationService::LibreTranslate.new(ENV['LIBRE_TRANSLATE_ENDPOINT'], ENV['LIBRE_TRANSLATE_API_KEY'])
    elsif ENV['LINGVA_TRANSLATE_ENDPOINT'].present?
      TranslationService::LingvaTranslate.new(ENV['LINGVA_TRANSLATE_ENDPOINT'])
    else
      raise NotConfiguredError
    end
  end

  def self.configured?
    ENV['DEEPL_API_KEY'].present? || ENV['LIBRE_TRANSLATE_ENDPOINT'].present? || ENV['LINGVA_TRANSLATE_ENDPOINT'].present?
  end

  def translate(_text, _source_language, _target_language)
    raise NotImplementedError
  end
end
