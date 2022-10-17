desc 'Iterate over bjson data structure and replace all non-breaking spaces with spaces and remove all Â characters'
task fix_invalid_data_from_imports: :environment do
  Report.find_each do |report|
    data = report.data
    hash_iterator(data, report.id)
    report.update(data: data)
  end
end

def hash_iterator(hash, report_id)
  keys = hash.keys
  keys.each do |key|
    value = hash[key]

    if value.is_a?(Hash)
      hash_iterator(value, report_id)
    elsif value.is_a?(Array)
      array_iterator(value, report_id)
    elsif value.is_a?(String)
      clean_string(value, report_id)
    end
  end
end

def array_iterator(value_array, report_id)
  value_array.each do |value|
    if value.is_a?(String)
      clean_string(value, report_id)
    elsif value.is_a?(Hash)
      hash_iterator(value, report_id)
    elsif value.is_a?(Array)
      array_iterator(value, report_id)
    end
  end
end

def clean_string(value, report_id)
  non_breaking_space = value =~ /\u00a0/
  if non_breaking_space
    puts "removing non-breaking space from #{value} on Report ##{report_id}"
    value.gsub!(/\u00a0/," ")
  end

  invalid_character_index = value =~ /[Â]/
  if invalid_character_index
    puts "removing Â from #{value} on Report ##{report_id}"
    value.slice!(invalid_character_index)
  end
end
