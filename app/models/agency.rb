# == Schema Information
#
# Table name: agencies
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address_1  :string
#  address_2  :string
#  city       :string
#  post_code  :string
#  country    :string
#

class Agency < ActiveRecord::Base
  has_many :users

  validates :name, :email, :country, presence: true
end
