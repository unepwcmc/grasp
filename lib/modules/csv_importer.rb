require 'csv'

module CsvImporter
  def self.import(csv_path)
    errors = []
    reports = []
    line = 1

    CSV.foreach(csv_path, headers: true) do |row|
      converter = CsvConverter.new(Report.new)

      column = 1
      row.each do |header, value|
        begin
          converter.convert(header, value)
          reports << converter.report
        rescue CsvConverter::CsvConversionError => e
          errors << {line: line, column: column, message: e.message}
        end

        column += 1
      end

      line += 1
    end

    if errors.any?
      {successful: false, errors: errors}
    else
      {successful: true, reports: reports}
    end
  end
end
