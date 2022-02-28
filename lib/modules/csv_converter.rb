class CsvConverter
  class CsvConversionError < RuntimeError; end
  attr_reader :report, :has_data

  def initialize report
    @has_data = false
    @report = report
    @report.data = {
      "answers" => {},
      "genera"  => {},
      "state"   => "Validated"
    }
  end

  def convert header, value
    invalid_header_error_message = "'#{header}' is not a valid column header."
    raise CsvConversionError, invalid_header_error_message unless self.class.columns.include? header

    if value && self.class.method_defined?(header)
      @has_data = true
      send(header.to_sym, value.strip)
    end
  end

  def add_genus value, type
    @report.data["genera"][type] ||= []

    unless @report.data["genera"][type].include?(value)
      @report.data["genera"][type] << value
    end
  end

  def answer question, value, page=nil
    if page
      @report.data["answers"][page] ||= [{}]
      @report.data["answers"][page][0][question] ||= {}
      @report.data["answers"][page][0][question]["selected"] = value
    else
      @report.data["answers"][question] ||= {}
      @report.data["answers"][question]["selected"] = value
    end
  end

  def answer_body_part part, value, float=false
    error_message = <<-ERROR
      Body parts data need a genus to be specified.
      Do you have a "Body Parts Genus (Ape)" column in your CSV?
    ERROR
    genus_name = @report.answer_to("genus_parts") or raise CsvConversionError, error_message
    question_name = "parts_#{find_genus(genus_name)}"

    selected = @report.answer_to(question_name) || {"parts" => {}}
    selected["parts"][part] = (float ? value.to_f : value.to_i)

    answer(question_name, selected)
  end

  def answer_coords value
    coords = value.split(",")

    missing_error = "Incorrect GPS coordinates supplied. Lat or long are missing."
    raise CsvConversionError, missing_error if coords.size != 2

    lat_conversion_error = "Incorrect GPS coordinates supplied. Latitude is not a valid number"
    lat = Float(coords.first.strip) rescue(raise CsvConversionError, lat_conversion_error)

    lng_conversion_error = "Incorrect GPS coordinates supplied. Longitude is not a valid number"
    lng = Float(coords.last.strip) rescue(raise CsvConversionError, lng_conversion_error)

    answer("location_coords", {lat: lat, lng: lng})
  end

  def find_user value
    user = User.where(%q(first_name || ' ' || last_name = ?), value).first
    error_message = "Can't find user with full name '#{value}'."

    user or raise CsvConversionError, error_message
  end

  def find_genus value
    genera = {
      "Bonobo (Pan)" => "bonobo",
      "Chimpanzee (Pan)" => "chimpanzee",
      "Gorilla (Gorilla)" => "gorilla",
      "Orangutan (Pongo)" => "orangutan",
      "Unknown" => "unknown"
    }

    error_message = "Can't find genus '#{value}'. Available genera are #{genera.keys.join(", ")}"
    genera[value] or raise CsvConversionError, error_message
  end

  CONVERSIONS = {
    "User Name"                => proc { |value| @report.user = find_user(value) },
    "Own Agency?"              => proc { |value| answer("own_organisation", value) },
    "Country of Discovery"     => proc { |value| answer("country_of_discovery", value) },
    "Region of Discovery"      => proc { |value| answer("region_of_discovery", value) },
    "Date of Discovery"        => proc { |value| answer("date_of_discovery", value) },
    "GPS Location"             => proc { |value| answer_coords(value) },
    "Type of Location"         => proc { |value| answer("type_of_location", value) },
    "Live Ape (Genus)"         => proc { |value|
      answer("genus_live", value, "live")
      add_genus(value, "live")
    },
    "Live Species/Subspecies"  => proc { |value| answer("species_subspecies_live", value, "live") },
    "Live Intended Use"        => proc { |value| answer("intended_use_live", value, "live") },
    "Live Age"                 => proc { |value| answer("age_live", value, "live") },
    "Live Gender"              => proc { |value| answer("gender_live", value, "live") },
    "Live Last Location"       => proc { |value| answer("last_known_location_live", value, "live") },
    "Live Country of Origin"   => proc { |value| answer("alleged_origin_country_live", value, "live") },
    "Live Condition"           => proc { |value| answer("condition_live", value, "live") },
    "Live Ape For Sale"        => proc { |value| answer("ape_for_sale_live", value, "live") },
    "Live Sale Price"          => proc { |value| answer("sale_price_live", value, "live") },
    "Live Identifiers"         => proc { |value| answer("unique_identifiers_live", value, "live") },
    "Live Name"                => proc { |value| answer("individual_name_live", value) },
    "Dead Ape (Genus)"         => proc { |value|
      answer("genus_dead", value, "dead")
      add_genus(value, "dead")
    },
    "Dead Species/Subspecies"  => proc { |value| answer("species_subspecies_dead", value, "dead") },
    "Dead Intended Use"        => proc { |value| answer("intended_use_dead", value, "dead") },
    "Dead Age"                 => proc { |value| answer("age_dead", value, "dead") },
    "Dead Gender"              => proc { |value| answer("gender_dead", value, "dead") },
    "Dead Last Location"       => proc { |value| answer("last_known_location_dead", value, "dead") },
    "Dead Country of Origin"   => proc { |value| answer("alleged_origin_country_dead", value, "dead") },
    "Dead Condition"           => proc { |value| answer("condition_dead", value, "dead") },
    "Dead Identifiers"         => proc { |value| answer("unique_identifiers_dead", value, "dead") },
    "Dead Name"                => proc { |value| answer("individual_name_dead", value, "dead") },
    "Body Parts (Genus)"       => proc { |value|
      answer("genus_parts", [value])
      add_genus(value, "parts")
    },
    "Bone (Femur) Qty"         => proc { |value| answer_body_part("bone_femur", value) },
    "Bone (Humerus) Qty"       => proc { |value| answer_body_part("bone_humerus", value) },
    "Foot Qty"                 => proc { |value| answer_body_part("foot", value) },
    "Hand Qty"                 => proc { |value| answer_body_part("hand", value) },
    "Skull Qty"                => proc { |value| answer_body_part("skull", value) },
    "Torso Qty"                => proc { |value| answer_body_part("torso", value) },
    "Confiscation?"            => proc { |value| answer("confiscated", value) },
    "Arrests Made?"            => proc { |value| answer("arrests_made", value) },
    "Prosecution?"             => proc { |value| answer("prosecution", value) },
    "Prosecution Successful?"  => proc { |value| answer("prosecution_successful", value) },
    "Punishment Successful?"   => proc { |value| answer("punishment", value) },
    "Other Illegal Activities" => proc { |value| answer("illegal_activities", value.split(",")) },
    "Man-made disturbances"    => proc { |value| answer("proximity", value.split(",")) }
  }

  CONVERSIONS.each do |header, method|
    self.send(:define_method, header, method)
  end

  def self.columns
    CONVERSIONS.keys
  end
end
