FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    area { Faker::Address.state }
    level { %w[普通 银牌 金牌 钻石].sample }
  end
end
