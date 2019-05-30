class UpdateOrangutanAnswers < ActiveRecord::Migration
  def change
    changes = {
      "Bornean orangutan (Pongo pygmaeus pygmaeus) – northwest populations" => "Northwest Bornean orangutan (Pongo pygmaeus pygmaeus)",
      "Bornean orangutan (Pongo pygmaeus morio) – east populations"         => "Northeast Bornean orangutan (Pongo pygmaeus morio)",
      "Bornean orangutan (Pongo pygmaeus wurmbii) – southwest populations"  => "Southwest Bornean orangutan (Pongo pygmaeus wurmbii)",
      "Sumatran orangutan (Pongo abelii)"                                   => "Sumatran orangutan (Pongo abelii)"
    }

    Report.all.each do |report|
      if live_apes = report.data.dig("answers", "live")
        report.data["answers"]["live"] = live_apes.map do |ape|
          selected = ape.dig("species_subspecies_live", "selected")
          ape["species_subspecies_live"]["selected"] = changes[selected] if changes[selected]

          ape
        end
      end

      if dead_apes = report.data.dig("answers", "dead")
        report.data["answers"]["dead"] = dead_apes.map do |ape|
          selected = ape.dig("species_subspecies_dead", "selected")
          ape["species_subspecies_dead"]["selected"] = changes[selected] if changes[selected]

          ape
        end
      end

      report.save
    end
  end
end
