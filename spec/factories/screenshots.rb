FactoryBot.define do
  factory :screenshot do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'body.jpg')) }
    project { create(:project) }
  end
end
