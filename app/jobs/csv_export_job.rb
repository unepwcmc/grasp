class CsvExportJob < ActiveJob::Base
  queue_as :default

  def perform(report_ids, user)
    # Active Job cannot serialize a collection so we look them up from an array of IDs

    reports   = Report.find(report_ids)
    filepath  = CsvBuilder.build(reports)
    NotificationMailer.notify_user_of_csv_export_ready(user, filepath).deliver_later
  end
end
