# == Schema Information
#
# Table name: expertises
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Expertise < ActiveRecord::Base
  has_and_belongs_to_many :users
end
