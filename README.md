# Ticket System

Ticketing System.

## External Dependencies

This web application is written with Ruby using the Ruby on Rails framework and a MySQL database. You need Ruby version '2.5.1' for the application to work

- To install rvm , visit [RVM](https://rvm.io/rvm/install)
- To install this ruby version, you can run the command below but you can use other channels to install it as well e.g. `rbenv`.
  ```bash
  rvm install ruby-2.4.1
  ```
- To install PostgreSQL, run
  ```bash
  brew install mysql
  ```

_To know more about Ruby or Rails visit [Ruby Lang](https://www.ruby-lang.org) or [Ruby on Rails](http://rubyonrails.org/)._

## Installation

Please make sure you have **Ruby(v 2.4.1) and mysql** installed. Take the following steps to setup the application on your local machine:

1. Run `bundle install` to install all required gems

2. Run `yarn`

## Database

### Configuring the database

- After creating your `config/application.yml`, you need to create a database. To create them, run:

  ```bash
    rails db:setup
    rails db:migrate
  ```

## Tests

- Run test with `bundle exec rspec`
