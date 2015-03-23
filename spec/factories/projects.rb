# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    title 'First project'
    content 'first project content'
    collage { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'body.jpg')) }
    livelink 'http://test.webgate.pro'
  end
end
