require 'csv'

module CsvBuilder
  def self.build(reports)
    column_names = ["ID", "Report Status", "User Name", "Agency", "Collaboration?", "Timestamp", "Country of Discovery",
                    "Region of Discovery", "Date of Discovery", "GPS Location", "Type of Location", "Ape Status",
                    # Looping names for live/dead
                    "Ape (Genus)", "Species/Subspecies", "Intended Use", "Photo", "Age", "Gender", "Last Location",
                    "Country of Origin", "Condition", "Identifiers", "Name",
                    # Additional looping columns for body parts
                    "Bone Qty", "Foot/Hand Qty", "Genitalia Qty", "Hair Qty", "Meat Kg", "Skin Qty", "Skull Qty",
                    # Report columns
                    "Confiscation?", "Arrests Made?", "Prosecution?", "Prosecution Successful?", "Punishment Successful?",
                    "Other Illegal Activities", "Man-made disturbances"]

    filepath = "#{Rails.root.to_s}/tmp/csv_export_#{DateTime.now.to_i}.csv"

    CSV.open(filepath, "wb") do |csv|
      csv << column_names
      reports.each do |report|
        # Make the first row for the report, no apes
        csv << self.make_report_row(report)

        # For each ape in live, dead and parts, make a row
        ['live', 'dead', 'parts'].each do |status|
          if report.data.dig('answers', status).present? # If any live/dead/parts
            report.data['answers'][status].each do |ape|
              csv << self.make_report_row(report, ape, status.to_sym)
            end

            # Iterate for parts?
          end
        end
      end
    end

    filepath
  end

  def self.make_report_row(report, ape=nil, status=nil)
    # If an ape is passed in, it create a row with the details of this ape,
    # if not, it leaves these details blank and just creates a report row

    report_data_1 = [
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

    ape_data = Array.new(19, nil)

    if ape.present?
      ape_data = [
        status.to_s.titleize,
        ape.dig("genus_#{status}", 'selected'),
        ape.dig("species_subspecies_#{status}", 'selected'),
        ape.dig("intended_use_#{status}", 'selected'),
        "Photo TBC",
        ape.dig("age_#{status}", 'selected'),
        ape.dig("gender_#{status}", 'selected'),
        ape.dig("last_known_location_#{status}", 'selected'),
        ape.dig("alleged_origin_country_#{status}", 'selected'),
        ape.dig("condition_#{status}", 'selected'),
        ape.dig("unique_identifiers_#{status}", 'selected'),
        ape.dig("individual_name_#{status}", 'selected')
      ]

      if status == :live or status == :dead
        # Add empty fields for body parts section
        ape_data += Array.new(7, nil)
      elsif status == :parts
        # Create a new row for each genus
        ape_data += Array.new(7, 0)

        #ape_data = Array.new(12, nil)
        #parts = self.sum_genus_parts(report)
        #ape_data += [
          #parts.dig('parts', 'bone', 'selected'),
          #parts.dig('parts', 'foot_hand', 'selected'),
          #parts.dig('parts', 'genitalia', 'selected'),
          #parts.dig('parts', 'hair', 'selected'),
          #parts.dig('parts', 'meat', 'selected'),
          #parts.dig('parts', 'skin', 'selected'),
          #parts.dig('parts', 'skull', 'selected')
        #]
      else
        ape_data += Array.new(7, nil)
      end
    end


    report_data_2 = [
      report.data.dig('answers', 'confiscated', 'selected'),
      report.data.dig('answers', 'arrests_made', 'selected'),
      report.data.dig('answers', 'prosecution', 'selected'),
      report.data.dig('answers', 'prosecution_successful', 'selected'),
      report.data.dig('answers', 'punishment', 'selected'),
      report.data.dig('answers', 'illegal_activities', 'selected')&.join(", "),
      report.data.dig('answers', 'proximity', 'selected')&.join(", ")
    ]

    # Join the segments to form the full row
    report_data_1 + ape_data + report_data_2
  end

  def self.sum_genus_parts(report)
    # Fetch, merge and sum the genus parts for each ape genus into one totalled hash
    genus = ['bonobo', 'chimpanzee', 'gorilla', 'orangutan', 'unknown']
    genus_parts = genus.map {|genus| report.data.dig('answers', "parts_#{genus}")}
    genus_parts.inject{|total, hash| total.deep_merge(hash) {|_, value_1, value_2| value_1 + value_2 }}
  end
end
