class Url < ApplicationRecord
  DEFAULT_TITLE = 'Default title'
  belongs_to :user
  has_many :short_urls

  validates_uniqueness_of :original_url
  validates_presence_of :original_url, :title
  validate :validate_url_format
  accepts_nested_attributes_for :short_urls

  def build_short_url
    short_urls.build.tap { |surl| surl.generate_url_hash }
  end

  private

  def validate_url_format
    uri = URI.parse(original_url)
    errors.add(:format, 'invalid url format') unless uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    errors.add(:format, 'invalid url format')
  end
end
