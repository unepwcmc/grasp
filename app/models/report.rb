# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_c7699d537d  (user_id => users.id)
#
#

class Report < ActiveRecord::Base
  include ParamsUtils
  include SearchBuilder

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

  def self.search(params)
    if params
      query = self
      query = SearchBuilder.by_report_id(query, params)
      query = SearchBuilder.by_country_of_discovery(query, params)
      query = SearchBuilder.by_date_created_range(query, params)
      query = SearchBuilder.by_agencies(query, params)
      query = SearchBuilder.by_genus(query, params)
      query = SearchBuilder.by_users(query, params)
      query = SearchBuilder.by_ape_name(query, params)
      query = SearchBuilder.by_last_known_location(query, params)
      query
    else
      self.all
    end
  end

end
