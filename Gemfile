# frozen_string_literal: true

source "https://rubygems.org"

# Pin: Rails 8.1 requires Ruby 3.4+, we're on Ruby 3.3
gem "rails", "~> 7.2.3"

gem "bootsnap", require: false
gem "importmap-rails"
gem "propshaft"
gem "puma", ">= 5.0"
gem "sqlite3", ">= 1.4"
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
  gem "rspec-rails", "~> 6.1"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end
