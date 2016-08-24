module ParamsUtils
  def self.strip_rails_defaults(params)
    params.except(:controller, :action, :utf8)
  end

  def self.strip_ordering_params(params)
    params = strip_rails_defaults(params)
    params.except(:sort, :dir)
  end

  def self.strip_empty(params)
    params.delete_if { |_, v| v.empty? }
    params.delete_if { |_, v| v == {"(1i)"=>"", "(2i)"=>"", "(3i)"=>""} }
  end

  def self.is_set_date?(date)
    if date["(1i)"].present? && date["(2i)"].present? && date["(3i)"].present?
      true
    else
      false
    end
  end

  def self.strip_to_search_params(params)
    params = strip_rails_defaults(params)
    params = strip_ordering_params(params)
    strip_empty(params)
  end

  def self.to_formatted_date(date_params)
    # Turns a date_select tag to a date object
    d = Date.new(
      date_params['(1i)'].to_i,
      date_params['(2i)'].to_i,
      date_params['(3i)'].to_i
    )
    d.strftime("%d/%m/%Y")
  end
end
