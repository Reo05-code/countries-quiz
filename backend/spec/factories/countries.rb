FactoryBot.define do
  factory :country do
    sequence(:name) { |n| "Test Country #{n}" }
    sequence(:reading) { |n| "てすとかんとりー#{n}" }
    hint_1 { "This is hint 1" }
    hint_2 { "This is hint 2" }
    hint_3 { "This is hint 3" }
    hint_4 { "This is hint 4" }
    flag_url { "https://flagcdn.com/w320/jp.png" }
  end
end
