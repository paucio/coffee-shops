# frozen_string_literal: true

FactoryBot.define do
  factory :bar do
    name { "Brewry" }
    sequence(:x) { |n| n.to_f }
    sequence(:y) { |n| (n + 0.5).to_f }
  end
end