# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :screenshot do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'body.jpg')) }
    association :project, factory: :project
  end
end
