FactoryBot.define do
  factory :quiz_attempt do
    association :user
    association :country
    correct { [true, false].sample }
    hint_level { rand(1..4) }
  end
end
