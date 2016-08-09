module Sorter
  COLUMNS = {
    "id" => "id",
    "username" => "users.first_name",
    "agency" => "agencies.name",
    "timestamp" => "created_at",
    "date_of_discovery" => "data->'questions'->'date_of_discovery'->>'selected'",
    "confiscated" => "data->'questions'->'confiscated'->>'selected'",
    "state" => "data->>'state'",
  }

  def self.sort collection, column, direction
    collection = collection.includes(user: :agency)
    order = build_column(column) + " " + build_direction(direction)

    collection.order(order)
  end

  def self.build_column column
    COLUMNS[column] || "created_at"
  end

  def self.build_direction direction
    %w[asc desc].include?(direction) ? direction : "desc"
  end
end
