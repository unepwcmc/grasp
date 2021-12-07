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

  def active_link_to text, url, html_opts={}
    if current_controller?(url)
      html_opts[:class] ||= ""
      html_opts[:class] << " is-active"
    end

    link_to text, url, html_opts
  end

  def current_controller?(url)
    info = Rails.application.routes.recognize_path url
    params[:controller] == info[:controller]
  end

  def display_or_default(data, default="N/A")
    data.present? ? data : default
  end

  # Bulk Upload index errors should persist so users can see the errors in their bulk upload
  def flash_should_persist?
    return false unless controller_name == 'bulk_uploads' && action_name == 'index'
    return false unless flash.present?

    begin
      flash.any? { |key, val| key == 'error' }
    rescue
      false
    end
  end
end
