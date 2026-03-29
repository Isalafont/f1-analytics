# frozen_string_literal: true

FactoryBot.define do
  factory :race do
    sequence(:name) { |n| "Grand Prix #{n}" }
    circuit { "Circuit Name" }
    country { "Country" }
    sequence(:round) { |n| n }
    season { 2026 }
    date { Date.current + 7.days }
    status { :scheduled }
  end
end
