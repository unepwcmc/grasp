class AddUserIdToReports < ActiveRecord::Migration
  def change
    add_belongs_to :reports, :user, index: true
  end
end
