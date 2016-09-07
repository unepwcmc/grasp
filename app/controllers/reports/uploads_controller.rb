class Reports::UploadsController < ApplicationController
  # FIXME - Cancancan not locking the namespaced controller
  # authorize_resource :class => false

  def new
  end

  def create
    file = params[:file]

    User.all_admins.each do |admin|
      NotificationMailer.notify_all_admins_of_csv_uploaded(current_user, admin, file).deliver_later
    end

    redirect_to reports_path, notice: "Thank you! Your multiple records file has been successfully submitted."
  end

  def download_template
    send_file(
      "#{Rails.root}/public/template.csv",
      filename: "grasp_csv_template.csv",
      type: "text/csv"
    )
  end
end
