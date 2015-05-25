namespace :db do
  desc 'Create 100 fake members to test pagination'
  task populate: :environment do
    50.times do
      Technology.create(title: Faker::Name.title, description: Faker::Lorem.paragraph, technology_group: TechnologyGroup.all.sample, link: Faker::Internet.url)
    end
    20.times do
      name = Faker::Name.name
      job = Faker::Lorem.word
      description = Faker::Lorem.paragraph(5)
      motto = Faker::Lorem.sentence(3, true, 4)
      member = Member.create name: name,
                             job_title: job,
                             description: description,
                             motto: motto,
                             publish: true
      src = File.join(Rails.root, "app/assets/images/yuri_skurikhin.png")
      src_file = File.new(src)
      member.avatar = src_file
      member.save!

      member.technologies << Technology.all
      5.times do
        member.member_links << MemberLink.create(name: Faker::Name.title, link: Faker::Internet.url)
      end
    end
  end
end
