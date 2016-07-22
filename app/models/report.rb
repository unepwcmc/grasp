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
# Foreign Keys
#
#  fk_rails_c7699d537d  (user_id => users.id)
#

class Report < ActiveRecord::Base
  belongs_to :user

  def self.search(params)
    if params
      query = self

      if params[:report_id].present?
        query = query.where(id: params[:report_id])
      end

      if params[:country_of_discovery].present?
        query = query.where("""data->'questions'->'country_of_discovery'->>'selected' = ?""", params[:country_of_discovery])
      end

      if params[:from_date].present? && params[:to_date].present?
        # Format the date_select tag to a date object
        f = params[:from_date]
        t = params[:to_date]
        from_date = DateTime.new(f['(1i)'].to_i, f['(2i)'].to_i, f['(3i)'].to_i).beginning_of_day
        to_date   = DateTime.new(t['(1i)'].to_i, t['(2i)'].to_i, t['(3i)'].to_i).end_of_day

        query = query.where(created_at: from_date..to_date)
      end

      if params[:agencies].present?
        agencies = params[:agencies].map(&:to_i)
        #query = query.where('user.agency.id' IS ANY OF agencies)
      end

    else
      self.all
    end
  end
end
