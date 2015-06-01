namespace :db do
  desc 'Load members techs'
  task load_members_techs: :environment do
    data = YAML.load_file(File.open('lib/member_techs.yml', 'r'))

    data.each do |a|
      a.each do |key, value|
        Member.find(key).technologies << Technology.find(value)
      end
    end
  end
end
