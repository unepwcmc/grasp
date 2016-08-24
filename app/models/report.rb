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
  has_many :validations

  def user_name
    "#{user&.first_name} #{user&.last_name}".strip
  end

  def timestamp
    created_at.strftime("%d/%m/%Y")
  end

  def state
    is_being_validated? ? "Being validated" : data["state"]&.humanize
  end

  CONVERSIONS = {
    "date_of_discovery" => lambda { |value| Date.strptime(value, "%Y-%m-%d") }
  }

  def answer_to question
    answer = data["answers"][question]["selected"]
    CONVERSIONS.has_key?(question) ? CONVERSIONS[question][answer] : answer
  rescue NoMethodError
    nil
  end

  def apes_by_type
    {live: apes_for("live"), dead: apes_for("dead")}
  end

  def apes_for(type)
    answers_for_type = Array.wrap(data.dig("answers", type))

    answers_for_type.each_with_object({}) do |ape, all_apes|
      genus = ape.dig("genus_#{type}", "selected")
      next unless genus

      all_apes[genus] ||= 0
      all_apes[genus] += 1
    end
  end

  def is_being_validated?
    $redis.exists("reports:#{id}:being_validated_by")
  end

  def being_validated_by
    return unless user_id = $redis.get("reports:#{id}:being_validated_by")
    User.find(user_id)
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
