# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Report < ActiveRecord::Base
  def self.search(params)
    if params
      self.find_by_sql([
        "SELECT * FROM reports r where r.id = ? OR
        r.data->'questions'->'country_of_discovery'->>'selected' = ?",
        params[:report_id], params[:country_of_discovery]
      ])
    else
      self.all
    end
  end
end
