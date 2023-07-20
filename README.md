##### Prerequisites

The setups steps expect following tools installed on the system.

- Git
- Ruby [3.2.2]
- Rails [7.0.5]
- Postgresql [15]
- redis-server [5.0.7]

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

##### 4. Run migration

```bash
docker-compose run app rails db:migrate
```
if necessary, you can add basic data

```bash
docker-compose run app rails db:seed
```
