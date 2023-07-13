FactoryBot.define do
  factory :project do
    title { FFaker::Book.title }
    content { FFaker::Lorem.paragraph }
    collage { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'body.jpg')) }
    livelink { 'http://test.webgate.pro' }
  end
end
