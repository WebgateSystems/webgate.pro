FactoryGirl.define do
  factory :member_link do
    name 'Tested Member_link'
    link 'http://test.webgate.pro'
    association :member, factory: :member
  end
end
