class AddTimestampsToBulkUploads < ActiveRecord::Migration
  def change
    add_timestamps :bulk_uploads
  end
end
