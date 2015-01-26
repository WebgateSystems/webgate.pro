# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    name 'Tested User'
    shortdesc 'Test shortdescription'
    description 'Test description'
    motto 'Test motto'
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'alex_dobr.jpg')) }
  end
end
