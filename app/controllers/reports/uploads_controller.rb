class Reports::UploadsController < ApplicationController
  # FIXME - Cancancan not locking the namespaced controller
  # authorize_resource :class => false

  def new
  end

  def create
    file_path = save_upload(params[:file])

    User.all_admins.each do |admin|
      NotificationMailer.notify_all_admins_of_csv_uploaded(current_user, admin, file_path.to_s).deliver_later
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

  private
    def save_upload file
      folder = Rails.root.join("tmp/csv_uploads")
      FileUtils.mkdir_p(folder)

      original_filename = File.basename(file.original_filename, ".csv")
      filename = "#{original_filename}_#{DateTime.now.strftime("%d%m%Y_%H%M%S")}.csv"

      File.open(folder.join(filename), "wb") { |f| f.write(file.read) }
      folder.join(filename)
    end
end
