FactoryBot.define do
  factory :technology do
    title { FFaker::Book.title }
    link { FFaker::Internet.http_url }
    technology_group { create(:technology_group) }
    description { FFaker::Lorem.paragraph }
    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'ws-logo.png')) }
  end
end
