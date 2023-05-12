# frozen_string_literal: true
# for Mastodon 4.0.2

class TranslationService::LingvaTranslate < TranslationService
  def initialize(base_url)
    super()

    @base_url = base_url
  end

  def translate(text, source_language, target_language)
    request(text, source_language, target_language).perform do |res|
      case res.code
      when 429
        raise TooManyRequestsError
      when 403
        raise QuotaExceededError
      when 200...300
        transform_response(res.body_with_limit, source_language)
      else
        raise UnexpectedResponseError
      end
    end
  end

  private

  def request(text, source_language, target_language)
    Request.new(:get, "#{@base_url}/api/v1/#{source_language}/#{target_language}/#{CGI::escape(text)}")
  end

  def transform_response(str, source_language)
    json = Oj.load(str, mode: :strict)

    raise UnexpectedResponseError unless json.is_a?(Hash)

    Translation.new(text: json['translation'], detected_source_language: source_language, provider: 'LingvaTranslate')
  rescue Oj::ParseError
    raise UnexpectedResponseError
  end
end
