class RemoteHtmlParserService < ApplicationService
  include Utils::UrlFormatValidation
  include ActionView::Helpers

  attr_reader :url, :queries, :sanitice, :as

  # @param [Url] url
  # @param [Array<String>] queries
  # @param [Hash] opts
  #   @option [Boolean] sanitize Default is TRUE
  #   @option [Symbol] as Default is :inner_html which returns output as DOM element inner html
  #   @option [Hash] headers
  def initialize(url:, queries:, opts: {})
    @result = Result.new(nil, errors)

    @url = url
    @queries = queries || ['root']
    @sanitice = opts[:sanitize]
    @sanitice = true if @sanitice.nil?
    @as = opts[:as] || :inner_html
    @headers = opts[:headers] || {}
  end

  # @example
  #   RemoteHtmlParserService.run(url: 'http://example.com', queries: ['head']).result
  #   # => {"head" => ['inner html of the queried element']}
  def run
    res = nil
    safely_execute do
      res = RestClient.get(url, @headers)
      # HTML parsing takes time, we won't bother parsing it if the reported content type is not html
      unless res.headers[:content_type]&.include?('text/html')
        add_error(:url, :content_type, 'Response is not in html format')
      end
    end
    return @result if has_error?

    @result.result = parse(res.body)
    @result
  end

  private

  # @return [Hash{String=>Array}]
  def parse(content)
    doc = Nokogiri::HTML.parse(content)
    queries.each_with_object({}) do |q, memo|
      elements = doc.search(q)
      memo[q] = elements.each_with_object([]) { |ele, memo2| memo2 << extract_element_result(ele) }
    end
  end

  def extract_element_result(element)
    return element unless inner_html_only?
    sanitice ? sanitize(element.inner_html) : element.inner_html
  end

  def inner_html_only?
    as == :inner_html
  end

  def safely_execute
    yield
  rescue StandardError => e
    add_error(:url, :http, e.message)
  end
end
