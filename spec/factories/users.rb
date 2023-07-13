FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password  { 'secret' }
  end
end
