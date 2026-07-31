FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    category { Faker::Commerce.department(max: 1) }
    price { Faker::Commerce.price(range: 1..1000.0) }
    status { :active }

    trait :inactive do
      status { :inactive }
    end
  end
end
