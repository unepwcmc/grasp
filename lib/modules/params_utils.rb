module ParamsUtils
  def self.strip_rails_defaults(params)
    params.except(:controller, :action, :utf8)
  end

  def self.strip_empty(params)
    params.delete_if { |k, v| v.empty? }
    params.delete_if { |k, v| v == {"(1i)"=>"", "(2i)"=>"", "(3i)"=>""} }
  end

  def self.is_set_date?(date)
    if date["(1i)"].present? && date["(2i)"].present? && date["(3i)"].present?
      true
    else
      false
    end
  end
end
