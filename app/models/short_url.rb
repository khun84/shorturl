class ShortUrl < ApplicationRecord
  belongs_to :url
  MAX_LENGTH = 15
  MIN_LENGTH = 5
  RANDOM_LENGTHS = [5..15].to_a.freeze

  validates_presence_of :url_hash
  validates_uniqueness_of :url_hash
  validates_length_of :url_hash, maximum: MAX_LENGTH, minimum: MIN_LENGTH

  # @param [Integer] length
  # @return [String]
  def self.generate_url_hash(length: nil)
    length ||= RANDOM_LENGTHS.shuffle.first
    val = SecureRandom.alphanumeric(length)
    return val if val.size == length
    val[0...length]
  end

  # @param [Integer] length
  def generate_url_hash(length: nil)
    self.url_hash = self.class.generate_url_hash(length: length)
  end
end
