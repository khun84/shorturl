FactoryBot.define do
  factory :short_url do
    association(:url)
    url_hash { SecureRandom.hex 5 }
  end
end
