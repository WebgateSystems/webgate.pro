# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :technology_group do
    title { Faker::Name.title }
    description { Faker::Lorem.paragraph }
  end
end
