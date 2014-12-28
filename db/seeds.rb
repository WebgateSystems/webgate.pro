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
