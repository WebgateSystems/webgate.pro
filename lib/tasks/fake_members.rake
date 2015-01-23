namespace :db do
  desc 'Create 100 fake members to test pagination'
  task populate: :environment do
    100.times do
      name = Faker::Name.name
      shortdesc = Faker::Lorem.sentence(3, true, 10)
      description = Faker::Lorem.paragraph(5)
      motto = Faker::Lorem.sentence(3, true, 4)
      member = Member.create name: name,
                             shortdesc: shortdesc,
                             description: description,
                             motto: motto
      src = File.join(Rails.root, "app/assets/images/alex_dobr.jpg")
      src_file = File.new(src)
      member.avatar = src_file
      member.save!
    end
  end
end