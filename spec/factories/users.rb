FactoryGirl.define do

  factory :user do
    sequence(:email) {|n| "example#{n}@webgate.pro" }
    password 'secret'
  end
end
