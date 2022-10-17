require "minitest/autorun"

class CsvConverterTest < ActiveSupport::TestCase
  # TO DO: Write tests for the remaining methods on this class.
  # CONVERSIONS = {
  #   "User Name"                => proc { |value| @report.user = find_user(value) },
  #   "Own Agency?"              => proc { |value| answer("own_organisation", value) },
  #   "Country of Discovery"     => proc { |value| answer("country_of_discovery", value) },
  #   "Region of Discovery"      => proc { |value| answer("region_of_discovery", value) },
  
  #   "GPS Location"             => proc { |value| answer_coords(value) },
  #   "Type of Location"         => proc { |value| answer("type_of_location", value) },
  #   "Live Ape (Genus)"         => proc { |value|
  #     answer("genus_live", value, "live")
  #     add_genus(value, "live")
  #     add_quantity(value, "live")
  #   },
  #   "Live Species/Subspecies"  => proc { |value| answer("species_subspecies_live", value, "live") },
  #   "Live Intended Use"        => proc { |value| answer("intended_use_live", value, "live") },
  #   "Live Age"                 => proc { |value| answer("age_live", value, "live") },
  #   "Live Gender"      proc { |value| answer("age_dead", value, "dead") },
  #   "Dead Gender"              => proc { |value| answer("gender_dead", value, "dead") },
  #   "Dead Last Location"       => proc { |value| answer("last_known_location_dead", value, "dead") },
  #   "Dead Country of Origin"   => proc { |value| answer("alleged_origin_country_dead", value, "dead") },
  #   "Dead Condition"           => proc { |value| answer("condition_dead", value, "dead") },
  #   "Dead Identifiers"         => proc { |value| answer("unique_identifiers_dead", value, "dead") },
  #   "Dead Name"                => proc { |value| answer("individual_name_dead", value, "dead") },
  #   "Body Parts (Genus)"       => proc { |value|
  #     answer("genus_parts", [value])
  #     add_genus(value, "parts")
  #     add_quantity(value, "body_parts")
  #   },
  #   "Bone (Femur) Qty"         => proc { |value| answer_body_part("bone_femur", value) },
  #   "Bone (Humerus) Qty"       => proc { |value| answer_body_part("bone_humerus", value) },
  #   "Foot Qty"                 => proc { |value| answer_body_part("foot", value) },
  #   "Hand Qty"                 => proc { |value| answer_body_part("hand", value) },
  #   "Skull Qty"                => proc { |value| answer_body_part("skull", value) },
  #   "Torso Qty"                => proc { |value| answer_body_part("torso", value) },
  #   "Confiscation?"            => proc { |value| answer("confiscated", value) },
  #   "Arrests Made?"            => proc { |value| answer("arrests_made", value) },
  #   "Prosecution?"             => proc { |value| answer("prosecution", value) },
  #   "Prosecution Successful?"  => proc { |value| answer("prosecution_successful", value) },
  #   "Punishment Successful?"   => proc { |value| answer("punishment", value) },
  #   "Other Illegal Activities" => proc { |value| answer("illegal_activities", value.split(",")) },
  #   "Man-made disturbances"    => proc { |value| answer("proximity", value.split(",")) }
  # end
  #       => proc { |value| answer("gender_live", value, "live") },
  #   "Live Last Location"       => proc { |value| answer("last_known_location_live", value, "live") },
  #   "Live Country of Origin"   => proc { |value| answer("alleged_origin_country_live", value, "live") },
  #   "Live Condition"           => proc { |value| answer("condition_live", value, "live") },
  #   "Live Ape For Sale"        => proc { |value| answer("ape_for_sale_live", value, "live") },
  #   "Live Sale Price"          => proc { |value| answer("sale_price_live", value, "live") },
  #   "Live Identifiers"         => proc { |value| answer("unique_identifiers_live", value, "live") },
  #   "Live Name"                => proc { |value| 
  #     answer("individual_name_live", value)
  #     answer("individual_name_live", value, 'live')
  #   },
  #   "Dead Ape (Genus)"         => proc { |value|
  #     answer("genus_dead", value, "dead")
  #     add_genus(value, "dead")
  #     add_quantity(value, "dead")
  #   },
  #   "Dead Species/Subspecies"  => proc { |value| answer("species_subspecies_dead", value, "dead") },
  #   "Dead Intended Use"        => proc { |value| answer("intended_use_dead", value, "dead") },
  #   "Dead Age"                 => proc { |value| answer("age_dead", value, "dead") },
  #   "Dead Gender"              => proc { |value| answer("gender_dead", value, "dead") },
  #   "Dead Last Location"       => proc { |value| answer("last_known_location_dead", value, "dead") },
  #   "Dead Country of Origin"   => proc { |value| answer("alleged_origin_country_dead", value, "dead") },
  #   "Dead Condition"           => proc { |value| answer("condition_dead", value, "dead") },
  #   "Dead Identifiers"         => proc { |value| answer("unique_identifiers_dead", value, "dead") },
  #   "Dead Name"                => proc { |value| answer("individual_name_dead", value, "dead") },
  #   "Body Parts (Genus)"       => proc { |value|
  #     answer("genus_parts", [value])
  #     add_genus(value, "parts")
  #     add_quantity(value, "body_parts")
  #   },
  #   "Bone (Femur) Qty"         => proc { |value| answer_body_part("bone_femur", value) },
  #   "Bone (Humerus) Qty"       => proc { |value| answer_body_part("bone_humerus", value) },
  #   "Foot Qty"                 => proc { |value| answer_body_part("foot", value) },
  #   "Hand Qty"                 => proc { |value| answer_body_part("hand", value) },
  #   "Skull Qty"                => proc { |value| answer_body_part("skull", value) },
  #   "Torso Qty"                => proc { |value| answer_body_part("torso", value) },
  #   "Confiscation?"            => proc { |value| answer("confiscated", value) },
  #   "Arrests Made?"            => proc { |value| answer("arrests_made", value) },
  #   "Prosecution?"             => proc { |value| answer("prosecution", value) },
  #   "Prosecution Successful?"  => proc { |value| answer("prosecution_successful", value) },
  #   "Punishment Successful?"   => proc { |value| answer("punishment", value) },
  #   "Other Illegal Activities" => proc { |value| answer("illegal_activities", value.split(",")) },
  #   "Man-made disturbances"    => proc { |value| answer("proximity", value.split(",")) }
  # end

  describe "#'Date of Discovery'" do
    it 'adds valid dates to the correct position in data' do
      report = Report.new
      csv_converter = CsvConverter.new(report)
      valid_date = '12/2/2021'
      csv_converter.convert('Date of Discovery', valid_date)
      report_date_field = report.data['answers']['date_of_discovery']['selected']
      _(report_date_field).must_equal valid_date
    end

    it 'does not add an invalid date to the report and it raises an error' do
      report = Report.new
      csv_converter = CsvConverter.new(report)
      invalid_date = '99/2/21'
      assert_raises(CsvConverter::CsvConversionError) { csv_converter.convert('Date of Discovery', invalid_date) }
      report_date_field = report.data.dig('answers', 'date_of_discovery', 'selected')
      _(report_date_field).must_equal nil
    end

    it 'does not add non-dates to the report and it raises an error' do
      report = Report.new
      csv_converter = CsvConverter.new(report)
      invalid_date = 'this is not a date'
      assert_raises(CsvConverter::CsvConversionError) { csv_converter.convert('Date of Discovery', invalid_date) }
      report_date_field = report.data.dig('answers', 'date_of_discovery', 'selected')
      _(report_date_field).must_equal nil
    end
  end
end