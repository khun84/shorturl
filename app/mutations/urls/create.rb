class Urls::Create < ApplicationMutation
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
    add_error(:url, :invalid, url.errors.full_messages.to_sentence) unless url.valid?
  end

  # @return [Url]
  def url
    return @url if @url
    title = url_title_result&.success? ? url_title_result.result : Url::DEFAULT_TITLE
    @url = user.urls.build(title: title, original_url: original_url)
    @url.build_short_url
    @url
  end

  # @return [ApplicationService::Result]
  def url_title_result
    @title_result ||= RemoteHtmlParserService.run(url: original_url, tags: ['title'])
  rescue StandardError => e
    Rails.logger.error({error: e.message, object_class: self.class.name})
  end
end
