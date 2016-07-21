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
      query = self

      if params[:report_id].present?
        query = query.where(id: params[:report_id])
      end

      if params[:country_of_discovery].present?
        query = query.where("""data->'questions'->'country_of_discovery'->>'selected' = ?""", params[:country_of_discovery])
      end
    else
      self.all
    end
  end
end
