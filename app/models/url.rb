class Url < ApplicationRecord
  belongs_to :user
  has_many :short_urls

  validates_uniqueness_of :original_url
  validates_presence_of :original_url, :title
  validate :validate_url_format

  private

  def validate_url_format
    uri = URI.parse(original_url)
    errors.add(:format, 'invalid url format') unless uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    errors.add(:format, 'invalid url format')
  end
end
