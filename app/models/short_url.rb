class ShortUrl < ApplicationRecord
  belongs_to :url
  MAX_LENGTH = 15
  MIN_LENGTH = 5
  RANDOM_LENGTHS = (5..15).entries.freeze

  validates_presence_of :url_hash
  validates_uniqueness_of :url_hash
  validates_length_of :url_hash, maximum: MAX_LENGTH, minimum: MIN_LENGTH

  delegate :original_url, :title, to: :url, allow_nil: true

  # @param [Integer] length
  # @return [String]
  def self.generate_url_hash(length: nil)
    length ||= RANDOM_LENGTHS.shuffle.first
    val = SecureRandom.alphanumeric(length)
    return val if val.size == length
    val[0...length]
  end

  def self.url_hash_to_url(url_hash)
    File.join(redirect_config.host.domain, redirect_config.route_namespace, url_hash)
  end

  # @return [String]
  def to_url
    self.class.url_hash_to_url(url_hash)
  end

  # @param [Integer] length
  def generate_url_hash(length: nil)
    self.url_hash = self.class.generate_url_hash(length: length)
  end

  def self.redirect_config
    Settings.redirection
  end

  def redirect_config
    self.class.redirect_config
  end
end
