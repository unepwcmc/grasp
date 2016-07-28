# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  role_id                :integer
#  first_name             :string
#  last_name              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  agency_id              :integer
#  second_email           :string
#  skype_username         :string
#  address_1              :string
#  address_2              :string
#  city                   :string
#  post_code              :string
#  country                :string
#
# Indexes
#
#  index_users_on_agency_id             (agency_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#
# Foreign Keys
#
#  fk_rails_627daf9bbe  (agency_id => agencies.id)
#  fk_rails_642f17018b  (role_id => roles.id)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :role
  belongs_to :agency
  has_and_belongs_to_many :expertises
  has_many :reports

  validates :role_id, :agency_id, :first_name, :last_name, :email, :country, presence: true

  def full_name
    [first_name, last_name].join(" ")
  end
end
