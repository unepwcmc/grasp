class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    mail = super

    mail.subject = "GRASP Database: #{mail.subject}"
    mail
  end
end
