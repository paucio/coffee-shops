# README

# Overview

You have been hired by a company that builds an app for coffee addicts. You are responsible for writing a REST API that offers the possibility to take the user's coordinates and return a list of the three closest coffee shops (including distance from the user) in order from the closest to farthest.

# Data

The coffee shops are stored in a remote CSV having these columns: Name,X,Y

The quality of data in this list of coffee shops may vary. Malformed entries should be handled appropriately.

Notice that the data file will be read from a network location (ex: https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv)

# API Response

A list of the three closest coffee shops (name, location and distance from the user) in order from the closest to farthest.
These distances should be rounded to four decimal places.
Assume all coordinates lie on a plane.
Use JSON API Specification for client requests and server responses.

# Example

For the provided coordinates X=47.6 and Y=-122.4 the response should contain these coffee shops:
	•	Starbucks Seattle2
	•	Starbucks Seattle
	•	Starbucks SF



## Ruby version

Ruby 4.0.5 (see `.ruby-version`)

## System dependencies

- Docker & Docker Compose

## Configuration

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

The following variables are required:

| Variable | Description |
|---|---|
| `POSTGRES_USER` | PostgreSQL username |
| `POSTGRES_PASSWORD` | PostgreSQL password |
| `DATABASE_URL` | Full PostgreSQL connection URL |
| `REDIS_URL` | Redis connection URL |
| `NEAREST_DEFAULT_LIMIT` | Default number of results returned (default: 3) |

## Starting the app

```bash
docker compose up
```

## Database creation & initialization

```bash
docker compose run --rm web bundle exec rails db:create db:migrate
```

## Import records

```bash
docker compose run --rm web bundle exec rails runner "CoffeeShopImportJob.perform_now('https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv')"
```

## How to run the test suite

```bash
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec
```

To run a specific file:

```bash
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec spec/requests/coffee_shops_spec.rb
```

