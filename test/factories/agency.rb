FactoryGirl.define do
  factory :agency do
    name              Faker::Company.name
    sequence(:email)  { |n| "agency#{n}@test.com" }
    url               Faker::Internet.url
    address_1         Faker::Address.street_address
    address_2         Faker::Address.street_name
    city              Faker::Address.city
    post_code         Faker::Address.postcode
    country           Faker::Address.country
  end
end

