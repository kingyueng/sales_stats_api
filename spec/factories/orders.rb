FactoryBot.define do
  factory :order do
    customer
    delivery_date { Faker::Date.forward(days: 30) }
  end
end
