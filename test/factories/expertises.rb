# == Schema Information
#
# Table name: expertises
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind       :text
#

FactoryGirl.define do
  factory :expertise do
    name "MyString"
  end
end
