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

    filepath = "#{Rails.root.to_s}/tmp/csv_export_#{DateTime.now.to_i}"

    CSV.open(filepath, "wb") do |csv|
      csv << column_names
      reports.each do |report|
        # For each ape, make a row
        report_data = [
          report.id,
          report.state,
          report.user.full_name,
          report.user.agency.name
          #report.data['questions']['derp']['selected']
        ]

        csv << report_data
      end
    end

    filepath
  end
end
