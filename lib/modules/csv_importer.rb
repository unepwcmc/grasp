require 'csv'

module CsvImporter
  def self.import(csv_path)
    happy_accidents = []
    reports = []
    line = 1

    CSV.foreach(csv_path, headers: true) do |row|
      converter = CsvConverter.new(Report.new)

      column = 1
      row.each do |header, value|
        begin
          converter.convert(header, value)
        rescue CsvConverter::CsvConversionError => e
          happy_accidents << {line: line, column: column, header: header, message: e.message}
        end

        column += 1
      end

      reports << converter.report if converter.has_data
      line += 1
    end

    if happy_accidents.any?
      {successful: false, happy_accidents: happy_accidents}
    else
      ActiveRecord::Base.transaction { reports.each(&:save!) }
      {successful: true, reports: reports}
    end
  end

  def self.generate_template
    CsvConverter.columns.join(",")
  end
end
