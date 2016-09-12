# ROLES
# Administrator   - GRASP
# Data validator  - TAG experts
# Data provider   - In the field conservationist/law enforcement/sanctuary worker

roles = ["admin", "validator", "provider"]
roles.each { |r| Role.where(name: r).first_or_create }

expertise = ["Bonobo (Pan)", "Gorilla (Gorilla)", "Chimpanzee (Pan)", "Orang-utan (Pongo)",
             "West Africa", "Central Africa", "East Africa", "Southeast Asia", "Rest of the World"]
expertise.each { |e| Expertise.where(name: e).first_or_create }

# Make life easier for devs...

if Rails.env == "development"
  role    = Role.find_by(name: "admin")
  agency  = Agency.create(name: "UNEP-WCMC", email: "informatics@unep-wcmc.org", country: "United Kingdom")

  User.where(email: "test@test.com").first_or_create do |u|
    u.first_name            = "Testy"
    u.last_name             = "McTestington"
    u.role                  = role
    u.agency                = agency
    u.email                 = "test@test.com"
    u.password              = "test1234"
    u.password_confirmation = "test1234"
    u.country               = "United Kingdom"
  end
end
