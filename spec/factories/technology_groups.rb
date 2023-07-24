FactoryBot.define do
  factory :technology_group do
    title { FFaker::Lorem.characters(10) }
    description { FFaker::Lorem.paragraph }
  end
end
