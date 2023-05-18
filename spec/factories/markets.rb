FactoryBot.define do
  factory :market do
    name { Faker::Company.name }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::Address.community }
    state { Faker::Address.state_abbr }
    zip { Faker::Number.number(digits: 5) }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end