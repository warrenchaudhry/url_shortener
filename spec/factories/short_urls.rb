FactoryBot.define do
  factory :short_url do
    full_url { nil }
    short_code { nil }
    title { nil }
    click_count { 0 }
  end
end