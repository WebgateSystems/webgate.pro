# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :technology_group do
    title { Faker::Name.title }
    description { Faker::Lorem.paragraph }
  end
  factory :technology_group_seq do
    sequence (:title) {|n| "tech group#{n}"}
    description 'tech group'
  end
end
