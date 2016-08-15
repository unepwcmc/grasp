class NotificationMailer < ApplicationMailer
  # Use for sending notification to a user or admin when they complete an action like joining a user or submitting a report

  def notify_all_admins_of_submitted_report(report)
    @report = report
    @admins = User.joins(:role).where(roles: {name: "admin"})

    @admins.each do |admin|
      @admin = admin
      mail(to: @admin.email, subject: 'GRASP Database: New Report Submitted')
    end
  end

  def notify_all_validators_of_submitted_report(validators, report)
    @report = report
    @validators = validators

    @validators.each do |validator|
      @validator = validator
      mail(to: @validator.email, subject: 'GRASP Database: New Report Submitted')
    end
  end

  def notify_user_of_account_creation(user, generated_password)
    @user = user
    @generated_password = generated_password
    mail(to: @user.email, subject: 'GRASP Database: Your account is ready')
  end

  def notify_user_of_csv_export_ready(user, file)
    @user = user
    @file = file
    mail(to: @user.email, subject: 'GRASP Database: Your CSV file is ready')
  end

  def notify_user_of_report_validated(validation)
    @validation = validation
    @user       = validation.user
    @report     = validation.report
    mail(to: @user.email, subject: 'GRASP Database: Your report has been Accepted')
  end

  def notify_user_of_report_returned(validation)
    @validation = validation
    @user       = validation.user
    @report     = validation.report
    mail(to: @user.email, subject: 'GRASP Database: Your report has been Accepted')
  end

  def notify_all_admins_of_report_validated(validation)
    @admins     = User.joins(:role).where(roles: {name: "admin"})
    @validation = validation
    @report     = validation.report

    @admins.each do |admin|
      @admin = admin
      mail(to: @admin.email, subject: 'GRASP Database: A report has been Validated')
    end
  end

  def notify_all_admins_of_report_returned(validation)
    @admins     = User.joins(:role).where(roles: {name: "admin"})
    @validation = validation
    @report     = validation.report

    @admins.each do |admin|
      @admin = admin
      mail(to: @admin.email, subject: 'GRASP Database: A report has been Returned')
    end
  end
end
