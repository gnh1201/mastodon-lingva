# frozen_string_literal: true

class TranslationService::LingvaTranslate < TranslationService
  def initialize(base_url)
    super()

    @base_url = base_url
  end

  def translate(text, source_language, target_language)
    request(:get, '/api/v1/#{source_language}/#{target_language}/#{text}') do |res|
      transform_response(res.body_with_limit, source_language)
    end
  end

  def languages
    request(:get, '/api/v1/languages') do |res|
      Oj.load(res.body_with_limit).languages.map { |language| language['code'] }
    end
  end

  private

  def request(verb, path, **options)
    req = Request.new(verb, "#{@base_url}#{path}", allow_local: true, **options)
    req.add_headers('Content-Type': 'application/json')
    req.perform do |res|
      case res.code
      when 429
        raise TooManyRequestsError
      when 403
        raise QuotaExceededError
      when 200...300
        yield res
      else
        raise UnexpectedResponseError
      end
    end
  end

  def transform_response(str, source_language)
    json = Oj.load(str, mode: :strict)

    raise UnexpectedResponseError unless json.is_a?(Hash)

    Translation.new(text: json['translation'], detected_source_language: source_language, provider: 'LingvaTranslate')
  rescue Oj::ParseError
    raise UnexpectedResponseError
  end
end
