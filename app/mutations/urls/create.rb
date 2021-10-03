class Urls::Create < ApplicationMutation
  include Utils::UrlFormatValidation
  HTML_TITLE_QUERY = 'head > title'.freeze

  required do
    model :user, class: User
    string :original_url
  end

  protected

  def execute
    Url.transaction do
      url.save!
    rescue ActiveRecord::TransactionRollbackError => e
      add_error(:url, :invalid, e.message)
    end
    url
  end

  def validate
    return add_error(:original_url, :invalid, 'Url is not valid') unless url_format_valid?(original_url)
    add_error(:url, :invalid, url.errors.full_messages.to_sentence) unless url.valid?
  end

  # @return [Url]
  def url
    return @url if @url
    title = url_title_result || Url::DEFAULT_TITLE
    @url = user.urls.build(title: title, original_url: original_url)
    @url.build_short_url
    @url
  end

  # @return [ApplicationService::Result]
  def url_title_result
    title_outcome = RemoteHtmlParserService.run(url: original_url, queries: [HTML_TITLE_QUERY])
    return title_outcome.result[HTML_TITLE_QUERY]&.first if title_outcome.success?
  rescue StandardError => e
    Rails.logger.error({error: e.message, object_class: self.class.name})
    nil
  end
end
