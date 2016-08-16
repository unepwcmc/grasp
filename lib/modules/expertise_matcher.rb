module ExpertiseMatcher
  def self.find_experts(report)
    # Takes a report and returns an array of the users matching expertise mentioned in that report

    country = report.data['answers']['country_of_discovery']['selected']
    #For each looping ape, get the genus
    #genus = report.data['questions']

    region = CountryUtilities.country_to_region(country)
    region = Expertise.find_by(name: region)
    region.users
  end
end
