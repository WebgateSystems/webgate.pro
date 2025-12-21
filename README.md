# webgate.pro

[![CI](https://github.com/WebgateSystems/webgate.pro/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/WebgateSystems/webgate.pro/actions/workflows/rubyonrails.yml)
![Coverage](https://img.shields.io/badge/coverage-95.9%25-brightgreen)
[![Ruby](https://img.shields.io/badge/Ruby-3.2.2-CC342D?logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-7.0.10-D30001?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)

## About

webgate.pro is a official website of Webgate Systems. Created with Ruby on Rails framework like a multilanguage application
for our internal purpose and, of course, to show what exactly we do and how.

Features
--------

* Edge technologies, for example RoR 4.2.1 caching style, asynchronous JS for SPDY etc.
* Automatic tests (covering more then 90%) with poltergeist or selenium (if you prefer to observe what's going on) to easy support and upgrade application/environment.

## License

webgate.pro is released under the [GNU General Public License](http://www.gnu.org/licenses/).


## Contributing

Since this is a completely free software under GPL license - **feel free to contribute**, improve its source code or give me constructive criticism.
Your git pull request will be pleasantly welcome.


#####Thanks a lot for feedback!
**team**


##### Prerequisites

The setups steps expect following tools installed on the system.

- Git
- Ruby [3.2.2]
- Rails [7.0.5]
- Postgresql [15]
- redis-server [5.0.7]
- java [11.0.19]

### Initial installation

##### 1. Create config/config.yml file

```bash
cp config/config.yml.example config/config.yml
```

##### 2. Create config/sidekiq.yml file

```bash
cp config/sidekiq.yml.example config/sidekiq.yml
```

### If you want to use without Docker:

##### 1. Install Gems

```bash
bundle exec bundle install
```

##### 2. Create .ENV file

The terminal must be in the root folder of the project

```bash
cp .env.example .env
```

Next we need to add the PG username and password

```bash
nano .env
```

For example: (User must be created locally in Postgresql)

```bash
POSTGRES_USER: 'your postgres user name'
POSTGRES_PASSWORD: 'your postgres user password'
```

##### 3. Create DB

```ruby
bundle exec rails db:create
```

##### 4. Run migration

```ruby
bundle exec rails db:migrate
```
if necessary, you can add basic data

```ruby
bundle exce rails db:seed
```

##### 5. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000



### If you want to use Docker: 

##### 1. .env file setup

The terminal must be in the root folder of the project

```bash
cp .env.example .env
```

Next we need to add the PG username and password

```bash
nano .env
```

For example: (User to be created in docker )

```bash
POSTGRES_USER: 'your postgres user name'
POSTGRES_PASSWORD: 'your postgres user password'
```
Also uncomment these lines

```bash
  POSTGRES_HOST
  REDIS_URL
```
##### 2. Start Project with Docker

```bash
docker compose --env-file .env up
```

##### 3. Create DB

```bash
docker-compose run app rails db:create
```
OR (this command will create and run migrate your database)

```bash
chmod +x create_db.sh
```

```bash 
./bin/create_db.sh
```

##### 4. Run migration

```bash
docker-compose run app rails db:migrate
```
if necessary, you can add basic data

```bash
docker-compose run app rails db:seed
```
