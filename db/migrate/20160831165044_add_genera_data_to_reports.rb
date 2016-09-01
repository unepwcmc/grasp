class AddGeneraDataToReports < ActiveRecord::Migration
  def change
    Report.all.each do |report|
      report.data["genera"] = {live: [], dead: [], parts: []}
      report.data["genera"][:live] = Array.wrap(report.data.dig("answers", "live")).map { |live_ape|
        live_ape.dig("genus_live", "selected")
      }.compact

      report.data["genera"][:dead] = Array.wrap(report.data.dig("answers", "dead")).map { |dead_ape|
        dead_ape.dig("genus_dead", "selected")
      }.compact

      report.data["genera"][:parts] = Array.wrap(report.data.dig("answers", "genus_parts", "selected"))
      report.save
    end
  end
end
