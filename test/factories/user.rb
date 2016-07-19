FactoryGirl.define do
  factory :user do
    first_name              Faker::Name.first_name
    last_name               Faker::Name.last_name
    password                "test1234"
    password_confirmation   "test1234"
    sequence(:email)        { |n| "user#{n}@test.com" }
    sequence(:second_email) { |n| "second_email#{n}@test.com" }
    skype_username          Faker::Internet.user_name
    address_1               Faker::Address.street_address
    address_2               Faker::Address.street_name
    city                    Faker::Address.city
    post_code               Faker::Address.postcode
    country                 Faker::Address.country
    agency # User belongs to...
    role # User belongs to...

    factory :admin do
      association :role, :factory => :role, :name => 'admin'
    end

    factory :validator do
      association :role, :factory => :role, :name => 'validator'
    end

    factory :provider do
      association :role, :factory => :role, :name => 'provider'
    end
  end
end
