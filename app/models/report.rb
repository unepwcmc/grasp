# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#

class Report < ActiveRecord::Base
  belongs_to :user

  def user_name
    "#{user&.first_name} #{user&.last_name}".strip
  end

  def timestamp
    created_at.strftime("%d/%m/%Y")
  end

  def state
    data["state"]&.humanize
  end

  def answer_to question
    data["questions"][question]["selected"]
  rescue NoMethodError
    nil
  end
end
