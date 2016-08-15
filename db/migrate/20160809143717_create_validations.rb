class CreateValidations < ActiveRecord::Migration
  def change
    create_table :validations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :report, index: true, foreign_key: true
      t.text :comments_for_provider
      t.text :comments_for_admin
      t.string :state

      t.timestamps null: false
    end
  end
end
