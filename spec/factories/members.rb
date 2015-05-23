# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    name { Faker::Name.name }
    job_title { Faker::Name.title }
    education { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraph }
    motto { Faker::Lorem.sentence }
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'yuri_skurikhin.png')) }
  end
end
