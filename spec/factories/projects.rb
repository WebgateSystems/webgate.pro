FactoryBot.define do
  factory :project do
    title { FFaker::Book.title }
    content { FFaker::Lorem.paragraph }
    collage { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/body.jpg').to_s) }
    livelink { 'http://test.webgate.pro' }
  end
end
