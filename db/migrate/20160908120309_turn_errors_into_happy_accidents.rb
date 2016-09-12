class TurnErrorsIntoHappyAccidents < ActiveRecord::Migration
  def change
    rename_column :bulk_uploads, :errors, :happy_accidents
  end
end
