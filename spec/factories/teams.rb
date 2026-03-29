# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    constructor { name }
    season { 2026 }
    active { true }
  end
end
