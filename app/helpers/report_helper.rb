module ReportHelper
  def status_of_apes report
    capture {
      if report.answer_to("genus_live")
        concat content_tag(:p, class: "u-no-margin") {
          concat content_tag(:strong, "Live ape(s)")
          concat tag("br")
          concat report.answer_to("genus_live")
        }
      end
      if report.answer_to("genus_dead")
        concat content_tag(:p, class: "u-no-margin") {
          concat content_tag(:strong, "Dead ape(s)")
          concat tag("br")
          concat report.answer_to("genus_dead")
        }
      end
    }
  end
end
