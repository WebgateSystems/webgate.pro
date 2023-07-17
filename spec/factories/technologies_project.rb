FactoryBot.define do
  factory :technologies_project do
    technology { create(:technology) }
    project { create(:project) }
    position { 0 }
  end
end
