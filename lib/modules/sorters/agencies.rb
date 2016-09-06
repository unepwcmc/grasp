module Sorters::Agencies
  COLUMNS = {
    "name" => "agencies.name",
    "email" => "agencies.email",
    "url" => "agencies.url",
  }

  def self.sort collection, column, direction
    order = build_column(column) + " " + build_direction(direction)
    collection.order(order)
  end

  def self.build_column column
    COLUMNS[column] || "agencies.name"
  end

  def self.build_direction direction
    %w[asc desc].include?(direction) ? direction : "desc"
  end
end
