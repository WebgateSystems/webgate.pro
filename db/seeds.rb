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

if Member.count == 0
  I18n.locale = 'ru'
  member = Member.create name: 'Александр Добровольский',
                job_title: 'Студент киевского политехнического института. Ruby on Rails developer.',
                description: 'Я - студент 2 курса, киевского политехнического института.',
                motto: 'Harder,better, faster, stronger!'
  member.avatar = Rails.root.join('app/assets/images/alex_dobr.jpg').open
  member.save!

  member = Member.create name: 'Юрий Скурихин',
                job_title: 'Ruby on Rails разработчик',
                description: "<p>На рельсах с 2014 года</p>\r\n\r\n<p>- *nix<br />\r\n- ruby<br />\r\n- Rails 4<br />\r\n- PostgreSQL<br />\r\n- тестирование (rspec, capybara)&nbsp;<br />\r\n- Git (git flow)<br />\r\n- Github, Gitlab<br />\r\n- Slim, Haml<br />\r\n- CoffeeScript/JS<br />\r\n- jQuery(UI)<br />\r\n- AJAX<br />\r\n- SASS/CSS<br />\r\n- JSON API<br />\r\n- Heroku<br />\r\n- AWS<br />\r\n- Bootstrap<br />\r\n- Foundation<br />\r\n- Интеграция с внешними веб-сервисами<br />\r\n- Реализация мобильных версий</p>\r\n",
                education: "<h4><strong>Московский Университет Государственного Управления</strong></h4>\r\n\r\n<p>Инженер-программист -&nbsp;Информационные системы в экономике</p>\r\n\r\n<p>2003 - 2008</p>\r\n",
                motto: 'Per aspera ad astra'
  member.avatar = Rails.root.join('app/assets/images/yuri_skurikhin.png').open
  member.save!

  I18n.locale = 'en'
  #todo

  member = Member.find 2
  member.name = 'Yuri Skurikhin'
  member.job_title = 'Ruby on Rails Developer'
  member.description = "<ul>\r\n\t<li>With Rails in 2014</li>\r\n\t<li>Programming languages: Ruby, JavaScript</li>\r\n\t<li>DMSs: PostgreSQL, MongoDB</li>\r\n\t<li>Web frameworks: Ruby on Rails</li>\r\n\t<li>JavaScript libraries: JQuery, Ember</li>\r\n\t<li>Markup languages, template engines: HTML, XML, ERB, Haml, Slim, Markdown</li>\r\n\t<li>SCMs: Git (git flow)</li>\r\n\t<li>Operating systems: Linux, Windows</li>\r\n</ul>\r\n"
  member.education = "<h4><strong>Moscow University Governance</strong></h4>\r\n\r\n<p>Engineer&#39;s degree -&nbsp;Programming and Economy</p>\r\n\r\n<p>2003 - 2008</p>\r\n"
  member.motto = 'Per aspera ad astra'
  member.save

  I18n.locale = 'pl'
  #todo

  member = Member.find 2
  member.name = 'Yuri Skurikhin'
  member.job_title = 'Ruby on Rails Developer'
  member.description = "<ul>\r\n\t<li>With Rails in 2014</li>\r\n\t<li>Programming languages: Ruby, JavaScript</li>\r\n\t<li>DMSs: PostgreSQL, MongoDB</li>\r\n\t<li>Web frameworks: Ruby on Rails</li>\r\n\t<li>JavaScript libraries: JQuery, Ember</li>\r\n\t<li>Markup languages, template engines: HTML, XML, ERB, Haml, Slim, Markdown</li>\r\n\t<li>SCMs: Git (git flow)</li>\r\n\t<li>Operating systems: Linux, Windows</li>\r\n</ul>\r\n"
  member.education = "<h4><strong>Moscow University Governance</strong></h4>\r\n\r\n<p>Engineer&#39;s degree -&nbsp;Programming and Economy</p>\r\n\r\n<p>2003 - 2008</p>\r\n"
  member.motto = 'Per aspera ad astra'
  member.save

end

if Project.count == 0
  I18n.locale = 'ru'
  project = Project.create title: 'Сервис Auto Centrum',
                content: 'Сервис Auto Centrum',
                livelink: 'http://autocentrumserwis.pl',
                publish: true
  project.collage = Rails.root.join("app/assets/images/collage1.jpg").open
  project.save!


  I18n.locale = 'en'
  #todo

  project = Project.find 1
  project.title = 'Auto Service Centrum'
  project.content = 'Auto Service Centrum'
  project.save

  I18n.locale = 'pl'
  #todo

  project = Project.find 1
  project.title = 'Auto Centrum Serwis'
  project.content = 'Auto Centrum Serwis'
  project.save

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
  Technology.create title: 'Firebird', description: 'Firebird', technology_group_id: 1, logo: ''
  Technology.create title: 'PostgreSQL', description: 'PostgreSQL', technology_group_id: 1, logo: ''
  Technology.create title: 'MySQL', description: 'MySQL', technology_group_id: 1, logo: ''
  Technology.create title: 'SQLite', description: 'SQLite', technology_group_id: 1, logo: ''
  Technology.create title: 'MongoDB', description: 'MongoDB', technology_group_id: 1, logo: ''
  Technology.create title: 'riak', description: 'Riak', technology_group_id: 1, logo: ''
  Technology.create title: 'Cassandra', description: 'Cassandra', technology_group_id: 1, logo: ''

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
