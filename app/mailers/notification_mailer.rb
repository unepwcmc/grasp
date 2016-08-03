class NotificationMailer < ApplicationMailer
  # Use for sending notification to a user or admin when they complete an action like joining a user or submitting a report

  def notify_all_admins_of_submitted_report(report)
    @report = report
    @admins = User.where(role_id: 1)

    @admins.each do |admin|
      mail(to: @user.email, subject: 'Welcome to My Awesome Site')
    end
  end

  def notify_user_of_account_creation
  end
end
