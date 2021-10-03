class RemoteHtmlParserService < ApplicationService

  attr_reader :url, :tags
  # @param [Url] url
  # @param [Array<String>] tags
  def initialize(url:, tags:)
    @url = url
    @tags = tags
  end

  def run
  end
end
