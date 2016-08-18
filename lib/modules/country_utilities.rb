COUNTRIES = {
  "West Africa": ["Ivory Coast", "Ghana", "Guinea", "Guinea Bissau", "Liberia", "Mali", "Nigeria", "Senegal", "Sierra Leone"],
  "Central Africa": ["Angola", "Cameroon", "Central African Republic", "Democratic Republic of Congo", "Congo", "Equatorial Guinea", "Gabon"],
  "East Africa": ["Burundi", "Rwanda", "South Sudan", "Tanzania", "Uganda"],
  "Southeast Asia": ["Indonesia", "Malaysia"]
}

module CountryUtilities
  def self.country_to_region(country)
    hash = COUNTRIES.select { |_k,v| v.include? country }
    hash.keys.first.to_s
  end
end

