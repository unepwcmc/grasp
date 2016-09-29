class BulkUploadsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def show
  end

  def index
    @bulk_uploads = BulkUpload.includes(:reports).order(:created_at).page(params[:page])
  end

  def new
  end

  def edit
    @bulk_upload = BulkUpload.find(params[:id]) or raise_404
  end

  def update
    redirect_to(:back) and return if params[:file].nil?

    result = CsvImporter.import(params[:file].path)
    @bulk_upload = BulkUpload.find(params[:id]) or raise_404
    @bulk_upload.update(result)

    if result[:successful]
      redirect_to @bulk_upload, flash: {success: t("bulk_uploads.upload_successful")}
    else
      redirect_to @bulk_upload, flash: {error: t("bulk_uploads.upload_error")}
    end
  end

  def create
    redirect_to(:back) and return if params[:file].nil?

    result = CsvImporter.import(params[:file].path)
    if result[:successful]
      redirect_to BulkUpload.create(result), flash: {success: t("bulk_uploads.upload_successful")}
    else
      redirect_to BulkUpload.create(result), flash: {error: t("bulk_uploads.upload_error")}
    end
  end

  def destroy
    bulk_upload = BulkUpload.find(params[:id]) or raise_404
    bulk_upload.destroy

    redirect_to action: :index, notice: "That bulk upload has been successfully deleted from the system. Thank you!"
  end
end
