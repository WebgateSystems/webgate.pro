# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    name 'Tested User'
    job_title 'Tested Job'
    education 'Test education'
    description 'Test description'
    motto 'Test motto'
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'yuri_skurikhin.png')) }
  end
end
