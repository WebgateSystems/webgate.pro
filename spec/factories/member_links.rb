FactoryBot.define do
  factory :member_link do
    name { FFaker::Name.name }
    link { FFaker::Internet.http_url }
    position { 0 }
    member { create(:member) }
  end
end
