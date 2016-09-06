module Sorters::Users
  COLUMNS = {
    "first_name" => "users.first_name",
    "last_name" => "users.last_name",
    "email" => "users.email",
    "agency" => "agencies.name",
    "role" => "roles.name"
  }

  def self.sort collection, column, direction
    collection = collection.includes([:agency, :role])
    order = build_column(column) + " " + build_direction(direction)

    collection.order(order)
  end

  def self.build_column column
    COLUMNS[column] || "users.last_name"
  end

  def self.build_direction direction
    %w[asc desc].include?(direction) ? direction : "desc"
  end
end
