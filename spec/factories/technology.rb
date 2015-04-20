FactoryGirl.define do
  factory :technology do
    title 'tech'
    link 'http://example_tech.com/link'
    association :technology_group, factory: :technology_group
    description 'tech'
    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'ws-logo.png')) }
  end
end
