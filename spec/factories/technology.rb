FactoryBot.define do
  factory :technology do
    title { FFaker::Book.title }
    link { FFaker::Internet.http_url }
    technology_group { create(:technology_group) }
    description { FFaker::Lorem.paragraph }
    logo { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/ws-logo.png').to_s) }
  end
end
