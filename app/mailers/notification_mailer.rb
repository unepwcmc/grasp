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

  def notify_user_of_account_creation(user, generated_password)
    @user = user
    @generated_password = generated_password
    mail(to: @user.email, subject: 'GRASP Database: Your account is ready')
  end

  def notify_user_of_csv_export_ready(user, file)
    @user = user
    @file = file
    mail(to: @user.email, subject: 'GRASP Database: Your CSV export is ready to download')
  end
end
