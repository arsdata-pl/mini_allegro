# README

* Ruby version

Ruby 2.5.0p0

* System dependencies

Node.js for assets
postgresql headers

* Configuration

Nothing to configure

`bundle install --path vendor/bundle`

* Database creation

`bundle exec rails db:setup`

* Database initialization

`FILE_PATH=[PATH_TO_CSV] x rake data:seed_csv`

* How to run the test suite

`bundle exec rspec`

* Services (job queues, cache servers, search engines, etc.)

Elasticsearch for search
Postgresql for database
