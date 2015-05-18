namespace :db do
  desc 'Save members techs'
  task save_members_techs: :environment do
    array_of_hashes = []

    Member.all.each do |m|
      techs = []
      m.technologies.each do |t|
        techs << t.title
      end
      array_of_hashes << {m.name => techs}
    end

    File.open("lib/member_techs.yml", "w") do |file|
      file.write array_of_hashes.to_yaml
    end
  end
end
