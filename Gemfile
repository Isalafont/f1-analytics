# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.4.7"

gem "rails", "~> 8.1"

gem "bootsnap", require: false
gem "importmap-rails"
gem "propshaft"
gem "puma", ">= 5.0"
gem "solid_cache"
gem "solid_queue"
gem "sqlite3", ">= 2.0"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development do
  gem "web-console"
end

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails", "~> 8.0"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end
