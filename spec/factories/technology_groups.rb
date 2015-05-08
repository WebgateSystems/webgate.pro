# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :technology_group do
    title 'tech group'
    description 'tech group'
  end
  factory :technology_group_seq do
    sequence (:title) {|n| "tech group#{n}"}
    description 'tech group'
  end

end
