class CreateBulkUploads < ActiveRecord::Migration
  def change
    create_table :bulk_uploads do |t|
      t.json :errors
      t.boolean :successful
    end
  end
end
