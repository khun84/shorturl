FactoryBot.define do
  factory :url_click do
    url_hash { SecureRandom.alphanumeric 7 }
    # sequence(original_url_id) { |n| n }
    # sequence(short_url_id) { |n| n }
  end
end
