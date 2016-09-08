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

  def create
    result = CsvImporter.import(params[:file])
    redirect_to BulkUpload.create(result)
  end

  def destroy
    bulk_upload = BulkUpload.find(params[:id]) or raise_404
    bulk_upload.destroy

    redirect_to :index, notice: "That bulk upload has been successfully deleted from the system. Thank you!"
  end
end
