class AddColumnsToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :second_email, :string
    add_column :users, :skype_username, :string
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :city, :string
    add_column :users, :post_code, :string
    add_column :users, :country, :string
  end
end
