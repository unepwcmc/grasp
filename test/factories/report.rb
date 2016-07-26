FactoryGirl.define do
  factory :report do
    data nil
    user # Report belongs to
  end
end

