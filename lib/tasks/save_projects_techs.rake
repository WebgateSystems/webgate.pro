namespace :db do
  desc 'Save projects techs'
  task save_projects_techs: :environment do
    array_of_hashes = []

    Project.all.each do |p|
      techs = []
      p.technologies.each do |t|
        techs << t.id
      end
      array_of_hashes << {p.id => techs}
    end

    File.open('lib/project_techs.yml', 'w') do |file|
      file.write array_of_hashes.to_yaml
    end
  end
end
