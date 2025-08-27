# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    quantity { Faker::Number.within(range: 1..10) }
  end
end
