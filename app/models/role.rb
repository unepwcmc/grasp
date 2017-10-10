# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ApplicationRecord
  validates :name, presence: true
  has_many :users

  def titleized_name
    name.titleize
  end
end
