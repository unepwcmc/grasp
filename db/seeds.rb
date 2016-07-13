# ROLES
# Administrator   - GRASP
# Data validator  - TAG experts
# Data provider   - In the field conservationist/law enforcement/sanctuary worker

roles = ["admin", "validator", "provider"]
roles.each { |r| Role.where(name: r).first_or_create }

# Make life easier for devs...

if Rails.env == "development"
  role = Role.find_by(name: "admin")

  User.where(email: "test@test.com").first_or_create do |u|
    u.first_name            = "Testy"
    u.last_name             = "McTestington"
    u.role                  = role
    u.email                 = "test@test.com"
    u.password              = "test1234"
    u.password_confirmation = "test1234"
  end
end
