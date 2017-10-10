# == Schema Information
#
# Table name: reports
#
#  id             :integer          not null, primary key
#  data           :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  bulk_upload_id :integer
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test "#apes_by_type returns an hash of ape types" do
    report = FactoryGirl.create(:report, data: {
      answers: {
        live: [
          {genus_live: {selected: "Chimpanzee (pan)"}},
          {genus_live: {selected: "Bonobo (pan)"}},
          {genus_live: {selected: "Chimpanzee (pan)"}},
          {genus_live: {selected: "Gorilla (gorilla)"}}
        ],
        dead: [
          {genus_dead: {selected: "Bonobo (pan)"}},
          {genus_dead: {selected: "Chimpanzee (pan)"}},
          {genus_dead: {selected: "Unknown"}}
        ],
      }
    })

    assert_equal report.apes_by_type, {
      live: {
        "Chimpanzee (pan)" => 2,
        "Bonobo (pan)" => 1,
        "Gorilla (gorilla)" => 1
      },
      dead: {
        "Chimpanzee (pan)" => 1,
        "Bonobo (pan)" => 1,
        "Unknown" => 1
      }
    }
  end

  test "#is_being_validated? checks if a report is locked for validation" do
    report = FactoryGirl.create(:report)
    $redis.expects(:exists).with("reports:#{report.id}:being_validated_by").returns(true)

    assert report.is_being_validated?
  end

  test "#being_validated_by returns the user validating the report" do
    report = FactoryGirl.create(:report)
    validator = FactoryGirl.create(:validator)
    $redis.expects(:get).with("reports:#{report.id}:being_validated_by").returns(validator.id)

    assert_equal validator, report.being_validated_by
  end
end
