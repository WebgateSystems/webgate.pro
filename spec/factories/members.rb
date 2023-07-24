FactoryBot.define do
  factory :member do
    name { FFaker::Lorem.characters(10) }
    job_title { FFaker::Lorem.characters(10) }
    education { FFaker::Lorem.paragraph }
    description { FFaker::Lorem.paragraph }
    motto { FFaker::Lorem.sentence }
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/yuri_skurikhin.png').to_s) }
  end
end
