class AddUserRefToReports < ActiveRecord::Migration
  def change
    # changed this from add_reference as it conflicted with earlier migration from master branch
    add_foreign_key :reports, :users
  end
end
