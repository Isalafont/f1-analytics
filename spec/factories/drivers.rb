# frozen_string_literal: true

FactoryBot.define do
  factory :driver do
    sequence(:first_name) { |n| "Driver#{n}" }
    sequence(:last_name) { |n| "Last#{n}" }
    sequence(:number) { |n| n }
    sequence(:code) { |n| "D#{n.to_s.rjust(2, "0")}" }
    nationality { "GBR" }
    season { 2026 }
    active { true }
    association :team
  end
end
