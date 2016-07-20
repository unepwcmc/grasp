class AddColumnsToAgenciesTable < ActiveRecord::Migration
  def change
    add_column :agencies, :address_1, :string
    add_column :agencies, :address_2, :string
    add_column :agencies, :city, :string
    add_column :agencies, :post_code, :string
    add_column :agencies, :country, :string
  end
end
