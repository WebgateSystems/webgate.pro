FactoryGirl.define do
  factory :contact do
    name 'client'
    email 'client@example.com'
    content 'help me'

    factory :bot do
      nickname 'bot'
    end
  end
end
