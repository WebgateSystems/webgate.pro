FactoryGirl.define do
  factory :technology do
    title { Faker::Name.title }
    link { Faker::Internet.url }
    technology_group
    description { Faker::Lorem.paragraph }
    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'ws-logo.png')) }
  end
end
