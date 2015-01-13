# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if User.count == 0
  User.create email: "admin@webgate.pro", password: "admin789", password_confirmation: "admin789"
end

if TechnologyGroup.count == 0
  I18n.locale = 'en'
  TechnologyGroup.create title: 'Administration', description: 'Administartion technologies'
  TechnologyGroup.create title: 'Design', description: 'Design technologies'
  TechnologyGroup.create title: 'Frontend', description: 'Frontend technologies'
  TechnologyGroup.create title: 'Backend', description: 'Backend technologies'
  TechnologyGroup.create title: 'Mobile platforms', description: 'Mobile technologies'

  I18n.locale = 'pl'
  #todo

  I18n.locale = 'ru'
  t = TechnologyGroup.find 1
  t.title = "Администрирование"
  t.description = "Группа административных технологий"
  t.save

  t = TechnologyGroup.find 2
  t.title = "Дизайн"
  t.description = "Группа технологий дизайна"
  t.save

  t = TechnologyGroup.find 3
  t.title = "Фронтенд"
  t.description = "Группа фронтенд технологий"
  t.save

  t = TechnologyGroup.find 4
  t.title = "Бэкенд"
  t.description = "Группа бэкенд технологий"
  t.save

  t = TechnologyGroup.find 5
  t.title = "Мобильные платформы"
  t.description = "Мобильные технологии"
  t.save
end

if Technology.count == 0
  I18n.locale = 'en'
  Technology.create title: 'Oracle Database', description: 'Oracle Database', technology_group_id: 1, logo: ''
  Technology.create title: 'Microsoft SQL Server', description: 'Microsoft SQL Server', technology_group_id: 1, logo: ''
  Technology.create title: 'Firebird', description: 'Firebird', technology_group_id: 1, logo: ''
  Technology.create title: 'PostgreSQL', description: 'PostgreSQL', technology_group_id: 1, logo: ''
  Technology.create title: 'MySQL', description: 'MySQL', technology_group_id: 1, logo: ''
  Technology.create title: 'SQLite', description: 'SQLite', technology_group_id: 1, logo: ''
  Technology.create title: 'MongoDB', description: 'MongoDB', technology_group_id: 1, logo: ''

  I18n.locale = 'pl'
  #todo

  I18n.locale = 'ru'
  #todo
end


if Category.count == 0
  I18n.locale = 'pl'
  Category.create name: "Główna", :altlink => "/", position: 1
  Category.create name: "O nas", altlink: "o-nas", position: 2
  Category.create name: "Portfolio", altlink: "portfolio", position: 3
  Category.create name: "Zespół", altlink: "zespół", position: 4
  Category.create name: "Praca", altlink: "praca", position: 5
  Category.create name: "Kontakt", altlink: "#footer", position: 6

  I18n.locale = 'en'
  c = Category.find 1
  c.name = "Main"
  c.altlink = "/"
  c.save

  c = Category.find 2
  c.name = "About"
  c.altlink = "about"
  c.save

  c = Category.find 3
  c.name = "Portfolio"
  c.altlink = "portfolio"
  c.save

  c = Category.find 4
  c.name = "Team"
  c.altlink = "team"
  c.save

  c = Category.find 5
  c.name = "Job"
  c.altlink = "job"
  c.save

  c = Category.find 6
  c.name = "Contact"
  c.altlink = "#footer"
  c.save

  I18n.locale = 'ru'
  c = Category.find 1
  c.name = "Главная"
  c.altlink = "/"
  c.save

  c = Category.find 2
  c.name = "О нас"
  c.altlink = "о-нас"
  c.save

  c = Category.find 3
  c.name = "Портфолио"
  c.altlink = "портфолио"
  c.save

  c = Category.find 4
  c.name = "Команда"
  c.altlink = "команда"
  c.save

  c = Category.find 5
  c.name = "Работа"
  c.altlink = "работа"
  c.save

  c = Category.find 6
  c.name = "Контакт"
  c.altlink = "#footer"
  c.save
end


if Page.count == 0
  I18n.locale = 'pl'
  Page.create shortlink: '/', title: 'Główna', description: 'Główna',
              keywords: 'Główna', category_id: 1,
              content: "Główna", position: 1

  I18n.locale = 'en'
  c = Page.find 1
  c.shortlink = "/"
  c.title = "Main"
  c.description = "Main"
  c.keywords = "Main"
  c.content = "Main"
  c.save

  I18n.locale = 'ru'
  c = Page.find 1
  c.shortlink = "/"
  c.title = "Главная"
  c.description = "Главная"
  c.keywords = "Главная"
  c.content = "Главная"
  c.save


  I18n.locale = 'pl'
  Page.create shortlink: 'o-nas', title: 'O nas', description: 'O nas',
              keywords: 'Webgate Systems', category_id: 2,
              content: "O nas", position: 2

  I18n.locale = 'en'
  c = Page.find 2
  c.shortlink = "about"
  c.title = "About"
  c.description = "About"
  c.keywords = "About"
  c.content = "About"
  c.save

  I18n.locale = 'ru'
  c = Page.find 2
  c.shortlink = "о-нас"
  c.title = "О нас"
  c.description = "О нас"
  c.keywords = "О нас"
  c.content = "О нас"
  c.save
end
