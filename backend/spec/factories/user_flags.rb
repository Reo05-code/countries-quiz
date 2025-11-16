FactoryBot.define do
  factory :user_flag do
    association :user
    association :country
  end
end
