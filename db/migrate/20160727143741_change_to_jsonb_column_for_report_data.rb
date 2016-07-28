class ChangeToJsonbColumnForReportData < ActiveRecord::Migration
  def change
    change_column :reports, :data, :jsonb
  end
end
