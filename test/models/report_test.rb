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
end
