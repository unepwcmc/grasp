module ApplicationHelper
  def breadcrumb text, path=nil
    capture do
      concat icon("angle-right", class: "breadcrumbs__divider")
      concat(path ? link_to(text, path) : text)
    end
  end

  def alert_key_to_fa_icon key
    case key
    when "success" then "check"
    when "error" then "times-circle"
    else
      "info-circle"
    end
  end
end
