FactoryBot.define do
  factory :member do
    name { FFaker::Name.name }
    job_title { FFaker::Book.title }
    education { FFaker::Lorem.paragraph }
    description { FFaker::Lorem.paragraph }
    motto { FFaker::Lorem.sentence }
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'yuri_skurikhin.png')) }
  end
end
