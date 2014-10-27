FactoryGirl.define do

  factory :user do
    sequence(:email) {|n| "example#{n}@webgate.pro" }
    password "qjtc0xu0sbgfbz2exg3a"
  end
end
