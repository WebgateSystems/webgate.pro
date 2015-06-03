FactoryGirl.define do
  factory :link_translation do
    link { Faker::Lorem.word }
    locale 'en'
    link_type 'category'
  end
end
