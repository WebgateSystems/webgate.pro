# webgate.pro

[![CI](https://github.com/WebgateSystems/webgate.pro/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/WebgateSystems/webgate.pro/actions/workflows/rubyonrails.yml)
![Coverage](https://img.shields.io/badge/coverage-90.1%25-brightgreen)
[![Ruby](https://img.shields.io/badge/Ruby-3.2.2-CC342D?logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-7.0.10-D30001?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## About

webgate.pro is the official website of Webgate Systems. Created with Ruby on Rails framework as a multilingual application
for our internal purposes and, of course, to showcase what exactly we do and how.

## Features

* Modern Ruby on Rails 7.0 application with latest best practices
* Multilingual support (DE, EN, FR, PL, RU, UA) using Globalize gem
* Comprehensive test coverage (over 90%) with RSpec, Capybara, and Selenium WebDriver
* Background job processing with Sidekiq
* Image uploads and processing with CarrierWave
* Admin panel for content management
* SEO-friendly sitemap generation
* Docker support for easy development setup


## License

webgate.pro is released under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0).

## Contributing

Since this is free software under GPL license - **feel free to contribute**, improve its source code or provide constructive feedback.
Your pull requests are welcome!

Thanks a lot for feedback!

**Webgate Systems Team**


## Prerequisites

The setup steps expect the following tools installed on the system:

- Git
- Ruby 3.2.2
- Rails 7.0.10
- PostgreSQL 15
- Redis 5.0.7+
- Java 11+ (for image processing with ImageMagick)

## Installation

### Initial Setup

1. **Create config/config.yml file**

```bash
cp config/config.yml.example config/config.yml
```

2. **Create config/sidekiq.yml file**

```bash
cp config/sidekiq.yml.example config/sidekiq.yml
```

### Local Development (without Docker)

1. **Install Gems**

```bash
bundle install
```

2. **Create .env file**

The terminal must be in the root folder of the project.

```bash
cp .env.example .env
```

Edit the `.env` file and add your PostgreSQL credentials:

```bash
nano .env
```

For example (user must be created locally in PostgreSQL):

```bash
POSTGRES_USER='your_postgres_username'
POSTGRES_PASSWORD='your_postgres_password'
```

3. **Create Database**

```bash
bundle exec rails db:create
```

4. **Run Migrations**

```bash
bundle exec rails db:migrate
```

If necessary, you can add basic data:

```bash
bundle exec rails db:seed
```

5. **Start the Rails Server**

```bash
bundle exec rails s
```

Visit the site at http://localhost:3000



### Docker Development

1. **.env file setup**

The terminal must be in the root folder of the project.

```bash
cp .env.example .env
```

Edit the `.env` file and add your PostgreSQL credentials:

```bash
nano .env
```

For example:

```bash
POSTGRES_USER='your_postgres_username'
POSTGRES_PASSWORD='your_postgres_password'
```

Also uncomment these lines:

```bash
POSTGRES_HOST=postgres
REDIS_URL=redis://redis:6379/0
```

2. **Start Project with Docker**

```bash
docker compose --env-file .env up
```

3. **Create Database**

```bash
docker-compose run app rails db:create
```

OR use the provided script (this command will create and migrate your database):

```bash
chmod +x bin/create_db.sh
./bin/create_db.sh
```

4. **Run Migrations**

```bash
docker-compose run app rails db:migrate
```

If necessary, you can add basic data:

```bash
docker-compose run app rails db:seed
```

## Running Tests

```bash
bundle exec rspec
```

## Additional Information

- Admin panel is available at `/admin` (requires authentication)
- Default languages: DE, EN, FR, PL, RU, UA
- Background jobs are processed by Sidekiq
- Sitemaps are generated automatically
