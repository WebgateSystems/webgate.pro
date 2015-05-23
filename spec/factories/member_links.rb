FactoryGirl.define do
  factory :member_link do
    name { Faker::Name.title }
    link { Faker::Internet.url }
    member
  end
end
