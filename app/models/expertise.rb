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

class Expertise < ApplicationRecord
  has_and_belongs_to_many :users
end
