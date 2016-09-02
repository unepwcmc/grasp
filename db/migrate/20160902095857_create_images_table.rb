class CreateImagesTable < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :file
      t.references :report
    end
  end
end
