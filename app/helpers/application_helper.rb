module ApplicationHelper
  def breadcrumb text, path=nil
    capture do
      concat icon("angle-right", class: "breadcrumbs__divider")
      concat(path ? link_to(text, path) : text)
    end
  end
end
