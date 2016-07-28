class ChangeToJsonbColumnForReportData < ActiveRecord::Migration
  def change
    change_column :reports, :data, 'jsonb USING CAST(data AS jsonb)'
  end
end
