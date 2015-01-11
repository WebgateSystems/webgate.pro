# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    title 'First project'
    shortlink 'first_project'
    description 'first project'
    keywords 'first project'
    content 'first project content'
  end
end
