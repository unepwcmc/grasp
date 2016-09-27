class RenameOrangutan < ActiveRecord::Migration
  def change
    Expertise
      .where(name: "Orang-utan (Pongo)")
      .update_all(name: "Orangutan (Pongo)")

    Report.all.each do |report|
      if live_apes = report.data.dig("answers", "live")
        report.data["answers"]["live"] = live_apes.map do |ape|
          if ape.dig("genus_live", "selected") == "Orang-utan (Pongo)"
            ape["genus_live"]["selected"] = "Orangutan (Pongo)"
          end

          ape
        end
      end

      if dead_apes = report.data.dig("answers", "dead")
        report.data["answers"]["dead"] = dead_apes.map do |ape|
          if ape.dig("genus_dead", "selected") == "Orang-utan (Pongo)"
            ape["genus_dead"]["selected"] = "Orangutan (Pongo)"
          end

          ape
        end
      end

      if dead_apes = report.data.dig("answers", "body_parts")
        report.data["answers"]["body_parts"] = dead_apes.map do |ape|
          if orangutan_index = ape.dig("genus_parts", "selected").index("Orang-utan (Pongo)")
            ape["genus_parts"]["selected"][orangutan_index] = "Orangutan (Pongo)"
          end

          ape
        end
      end

      report.save
    end
  end
end
