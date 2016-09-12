class AddBulkUploadIdToReports < ActiveRecord::Migration
  def change
    add_reference :reports, :bulk_upload
  end
end
