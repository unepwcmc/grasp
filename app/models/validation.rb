# == Schema Information
#
# Table name: validations
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  report_id             :integer
#  comments_for_provider :text
#  comments_for_admin    :text
#  state                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_validations_on_report_id  (report_id)
#  index_validations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (user_id => users.id)
#

class Validation < ApplicationRecord
  belongs_to :user
  belongs_to :report
end
