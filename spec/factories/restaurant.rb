# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    name { "StakeHouse" }
    sequence(:x) { |n| n.to_f }
    sequence(:y) { |n| (n + 0.5).to_f }
  end
end