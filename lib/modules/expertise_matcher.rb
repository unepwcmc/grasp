module ExpertiseMatcher
  def self.find_experts(report)
    # Takes a report and returns an array of the users matching expertise mentioned in that report
    region = self.get_region_expertise(report)
    region.users
  end

  def self.is_expert?(report, user)
    # Returns true if the user is an expert in any area of that report
    region = self.get_region_expertise(report)
    region and user.expertises.include?(region)
  end

  def self.filter_by_users_expertise(reports, user)
    reports = reports.select { |r| self.is_expert?(r, user) }
    # Must return an active record relation for use with sorter
    report_ids = reports.collect { |r| r.id }
    Report.where(id: report_ids)
  end

  def self.get_region_expertise(report)
    # Returns the matching region expertise object for a given report
    country = report.data.dig('answers', 'country_of_discovery', 'selected')
    region = CountryUtilities.country_to_region(country) if country
    Expertise.find_by(name: region) if region
  end
end
