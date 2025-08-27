# frozen_string_literal: true

FactoryBot.define do
  factory :shopping_cart, class: Cart do
    total_price { Faker::Commerce.price(range: 0..10_000) }
    last_interaction_at { Time.current }
    status { :active }
  end
end
