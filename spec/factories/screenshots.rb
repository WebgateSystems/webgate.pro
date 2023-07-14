FactoryBot.define do
  factory :screenshot do
    file { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/body.jpg').to_s) }
    project { create(:project) }
  end
end
