# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    title { Faker::Name.title }
    content { Faker::Lorem.paragraph }
    collage { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'body.jpg')) }
    livelink 'http://test.webgate.pro'
  end
end
