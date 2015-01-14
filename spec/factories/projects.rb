# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    title 'First project'
    shortlink 'first_project'
    description 'first project'
    keywords 'first project'
    content 'first project content'
    # added for uploader tests
    screenshot1 Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/projects/tested.jpg')))
  end
end
