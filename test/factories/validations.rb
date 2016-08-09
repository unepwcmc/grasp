FactoryGirl.define do
  factory :validation do
    user nil
    report nil
    comments_for_provider "MyText"
    comments_for_admin "MyText"
    state "MyString"
  end
end
