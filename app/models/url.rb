class Url < ApplicationRecord
  DEFAULT_TITLE = 'Default title'
  include Utils::UrlFormatValidation
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
    url_format_valid?(original_url)
  end
end
