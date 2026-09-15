FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "password123" }
    role { :passenger }
  end

  factory :route do
    origin { Faker::Address.city }
    destination { Faker::Address.city }
  end

  factory :bus do
    association :owner, factory: :user, role: :bus_owner
    name { Faker::Vehicle.make_and_model }
    plate_number { Faker::Vehicle.unique.license_plate }
    total_seats { 40 }
  end

  factory :seat do
    association :bus
    seat_number { Faker::Number.unique.number(digits: 2).to_s }
  end

  factory :schedule do
    association :bus
    association :route
    departure_time { 1.day.from_now }
    arrival_time { 1.day.from_now + 4.hours }
    fare { 1500 }
  end
end
