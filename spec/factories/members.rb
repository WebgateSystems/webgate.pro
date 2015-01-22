# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    name 'Tested User'
    shortdesc 'Test shortdescription'
    description 'Test description'
    motto 'Test motto'
  end
end
