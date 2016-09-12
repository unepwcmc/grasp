# == Schema Information
#
# Table name: bulk_uploads
#
#  id              :integer          not null, primary key
#  happy_accidents :json
#  successful      :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

class BulkUpload < ActiveRecord::Base
  has_many :reports
end
