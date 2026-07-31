FactoryBot.define do
  factory :order_item do
    order
    product
    qty { Faker::Number.between(from: 1, to: 100) }
    price { Faker::Commerce.price(range: 1..500.0) }
  end
end
