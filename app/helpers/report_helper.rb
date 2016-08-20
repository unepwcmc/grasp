module ReportHelper
  def status_of_apes report
    apes_by_type = report.apes_by_type
    capture {
      if apes_by_type[:live].any?
        concat content_tag(:p, class: "u-no-margin") {
          concat content_tag(:strong, "Live ape(s)")
          apes_by_type[:live].each do |(type, quantity)|
            concat tag("br")
            concat "#{quantity} #{type}"
          end
        }
      end
      if apes_by_type[:dead].any?
        concat content_tag(:p, class: "u-no-margin") {
          concat content_tag(:strong, "Dead ape(s)")
          apes_by_type[:dead].each do |(type, quantity)|
            concat tag("br")
            concat "#{quantity} #{type}"
          end
        }
      end
    }
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:dir] == "asc") ? "desc" : "asc"
    css_class = "table__header".tap { |cl|
      cl << " is-#{direction}" if column == params[:sort]
    }

    link_to title, {sort: column, dir: direction}, class: css_class
  end
end
