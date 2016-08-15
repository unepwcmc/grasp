FactoryGirl.define do
  factory :validation do
    user # Belongs to
    report # Belongs to
    comments_for_provider Faker::Lorem.sentence
    comments_for_admin Faker::Lorem.sentence
    state ["Accepted", "Returned"].sample
  end
end
