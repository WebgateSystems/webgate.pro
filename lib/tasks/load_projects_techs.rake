namespace :db do
  desc 'Load projects techs'
  task load_projects_techs: :environment do
    data = YAML.load_file(File.open("lib/project_techs.yml", "r"))

    data.each do |a|
      a.each do |key, value|
        Project.find(key).technologies << Technology.find(value)
      end
    end
  end
end
