FactoryBot.define do
  factory :url do
    association(:user)
    sequence(:title) { |n| "original-url-#{n}" }
    sequence(:original_url) { |n| "https://example.com/original-url-#{n}" }
  end
end
