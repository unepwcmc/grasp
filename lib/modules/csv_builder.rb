require 'csv'

module CsvBuilder
  def self.build(reports)
    folder = Rails.root.join("public", "csv_exports")
    FileUtils.mkdir_p(folder)
    filepath = folder.join("csv_export_#{DateTime.now.to_i}.csv")

    CSV.open(filepath, "wb") do |csv|
      csv << self.build_column_names
      reports.each do |report|
        # Make the first row for the report, no apes
        csv << self.make_report_row(report)

        # Make a row for each live or dead ape, if any
        ['live', 'dead'].each do |status|
          report.data.dig('answers', status)&.each do |ape|
            csv << self.make_report_row(report, ape, status.to_sym)
          end
        end

        # Create a body parts row for each genus
        report.data.dig('genera', 'parts')&.each do |genus|
          csv << self.make_report_row(report, nil, :parts, genus)
        end
      end
    end

    filepath # Return the file path
  end

  def self.make_report_row(report, ape=nil, status=nil, genus=nil)
    # Construct the segments of a row, if the data is not needed,
    # return the same amount of columns with a nil value to make rows equal

    report_data       = self.build_report_data(report)
    ape_data          = ape ? self.build_ape_data(ape, status) : Array.new(12, nil)
    parts_data        = status == :parts ? self.build_parts_data(report, genus) : Array.new(7, nil)
    confiscation_data = self.build_confiscation_data(report)

    report_data + ape_data + parts_data + confiscation_data
  end

  def self.build_column_names
    [
      # Report metadata
      "ID",
      "Report Status",
      "User Name",
      "Agency",
      "Collaboration?",
      "Timestamp",
      "Country of Discovery",
      "Region of Discovery",
      "Date of Discovery",
      "GPS Location",
      "Type of Location",
      "Ape Status",
      # Looping names for live/dead
      "Ape (Genus)",
      "Species/Subspecies",
      "Intended Use",
      "Photo",
      "Age",
      "Gender",
      "Last Location",
      "Country of Origin",
      "Condition",
      "Was ape for sale?",
      "What was sale price?",
      "Identifiers",
      "Name",
      # Additional looping columns for body parts
      "Bone (Femur) Qty",
      "Bone (Humerus) Qty",
      "Foot Qty",
      "Hand Qty",
      "Skull Qty",
      "Torso Qty",
      # Confiscation columns
      "Confiscation?",
      "Arrests Made?",
      "Prosecution?",
      "Prosecution Successful?",
      "Punishment Successful?",
      "Other Illegal Activities",
      "Man-made disturbances"
    ]
  end

  def self.build_report_data report
    [
      report.id,
      report.state,
      report&.user&.full_name,
      report&.user&.agency&.name,
      report.data.dig('answers', 'own_organisation', 'selected'),
      report.created_at,
      report.data.dig('answers', 'country_of_discovery', 'selected'),
      report.data.dig('answers', 'region_of_discovery', 'selected'),
      report.answer_to("date_of_discovery")&.strftime("%d/%m/%Y"),
      report.data.dig('answers', 'location_coords', 'selected')&.values&.join(", "),
      report.data.dig('answers', 'type_of_location', 'selected')
    ]
  end

  def self.build_ape_data ape, status
    last_known_location = ape.dig("last_known_location_#{status}", 'selected')
    if last_known_location == "other" || last_known_location == "with other organisation (please specify)"
      other_answer = ape.dig("last_known_location_#{status}", 'other_answer')
      last_known_location = last_known_location + ": " + (other_answer || "n/a")
    end

    [
      status.to_s.titleize,
      ape.dig("genus_#{status}", 'selected'),
      ape.dig("species_subspecies_#{status}", 'selected'),
      ape.dig("intended_use_#{status}", 'selected'),
      "photo tbc",
      ape.dig("age_#{status}", 'selected'),
      ape.dig("gender_#{status}", 'selected'),
      last_known_location,
      ape.dig("alleged_origin_country_#{status}", 'selected'),
      ape.dig("condition_#{status}", 'selected'),
      ape.dig("ape_for_sale_#{status}", 'selected'),
      ape.dig("sale_price_#{status}", 'selected'),
      ape.dig("unique_identifiers_#{status}", 'selected'),
      ape.dig("individual_name_#{status}", 'selected')
    ]
  end

  def self.build_parts_data report, genus
    genus = self.to_db_name(genus)
    [
      report.data.dig('answers', "bone_femur_#{genus}", 'selected') || 0,
      report.data.dig('answers', "bone_humerus_#{genus}", 'selected') || 0,
      report.data.dig('answers', "foot_#{genus}", 'selected') || 0,
      report.data.dig('answers', "hand_#{genus}", 'selected') || 0,
      report.data.dig('answers', "skull_#{genus}", 'selected') || 0,
      report.data.dig('answers', "torso_#{genus}", 'selected') || 0
    ]
  end

  def self.build_confiscation_data report
    [
      report.data.dig('answers', 'confiscated', 'selected'),
      report.data.dig('answers', 'arrests_made', 'selected'),
      report.data.dig('answers', 'prosecution', 'selected'),
      report.data.dig('answers', 'prosecution_successful', 'selected'),
      report.data.dig('answers', 'punishment', 'selected'),
      report.data.dig('answers', 'illegal_activities', 'selected')&.join(", "),
      report.data.dig('answers', 'proximity', 'selected')&.join(", ")
    ]
  end

  def self.to_db_name genus
    genera = {
      "bonobo (pan)" => "bonobo",
      "chimpanzee (pan)" => "chimpanzee",
      "gorilla (gorilla)" => "gorilla",
      "orangutan (pongo)" => "orangutan",
      "unknown" => "unknown"
    }

    genera[genus.downcase]
  end
end
