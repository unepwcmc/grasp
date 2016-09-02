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

    link_to({sort: column, dir: direction}, class: css_class) do
      if column == params[:sort] && direction == "desc"
        concat content_tag(:i, "", class: "icon icon--closer  fa fa-sort-desc")
      elsif column == params[:sort] && direction == "asc"
        concat content_tag(:i, "", class: "icon icon--closer  fa fa-sort-asc")
      else
        concat content_tag(:i, "", class: "icon icon--closer  fa fa-sort")
      end

      concat title
    end
  end

  def report_state_description(state)
    case state
    when "Submitted"
      content_tag(:p, content_tag(:strong, "Submitted: ") + "This report has been submitted and is now ready to be validated.") + content_tag(:p, content_tag(:i, "", class: 'fa fa-warning') + "The report may continue to be edited, but changing certain fields may require the report to be submitted again")
    when "In progress"
      content_tag(:p, content_tag(:strong, "In progress: ") + "This report is in progress and has not yet been submitted")
    when "Validated"
      content_tag(:p, content_tag(:strong, "Validated: ") + "This report has been successfully validated." + content_tag(:p, content_tag(:i, "", class: 'fa fa-warning') + "The report may continue to be edited, but changing certain fields may cause the report to become unvalidated"))
    when "Returned"
      content_tag(:p, content_tag(:strong, "Returned: ") + "This report has been returned by a validator and requires updating before it can be submitted again")
    end
  end

  def format_search_value_for_display(key, value)
    case key
    when "agencies"
      value = value.map {|v| Agency.find(v).name }
      value = value.join(", ")
    when "users"
      value = value.map {|u| User.find(u).full_name }
      value = value.join(", ")
    when "status_live"
      value = "Yes"
    when "status_dead"
      value = "Yes"
    when "status_body_parts"
      value = "Yes"
    when "genus"
      value = value.join(", ")
    when "last_known_location"
      value = value.join(", ")
    when "from_date"
      value = ParamsUtils.to_formatted_date(value)
    when "to_date"
      value = ParamsUtils.to_formatted_date(value)
    when "country_of_discovery"
      value = value.join(", ")
    else
      value
    end

    content_tag(:span, content_tag(:strong, "#{key.titleize}: ") + value + ", ")
  end
end
