FactoryBot.define do
  factory :contact do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    content { FFaker::Book.description }
    nickname { '' }

    factory :bot do
      nickname { 'bot' }
    end
  end
end
