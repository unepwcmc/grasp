module Sorters::Reports
  COLUMNS = {
    "id" => "reports.id",
    "username" => "users.first_name",
    "agency" => "agencies.name",
    "timestamp" => "reports.created_at",
    "date_of_discovery" => "reports.data->'answers'->'date_of_discovery'->>'selected'",
    "confiscated" => "reports.data->'answers'->'confiscated'->>'selected'",
    "state" => "reports.data->>'state'",
  }

  def self.sort collection, column, direction
    collection = collection.includes(user: :agency)
    order = build_column(column) + " " + build_direction(direction)

    collection.order(order)
  end

  def self.build_column column
    COLUMNS[column] || "reports.created_at"
  end

  def self.build_direction direction
    %w[asc desc].include?(direction) ? direction : "desc"
  end
end
