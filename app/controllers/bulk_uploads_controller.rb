# frozen_string_literal: true

class BulkUploadsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def show; end

  def index
    @bulk_uploads = BulkUpload.includes(:reports).order(:created_at).page(params[:page])
  end

  def new; end

  def edit
    (@bulk_upload = BulkUpload.find(params[:id])) || raise_404
  end

  def update
    redirect_to(:back) && return if params[:file].nil?

    result = CsvImporter.import(params[:file].path)
    (@bulk_upload = BulkUpload.find(params[:id])) || raise_404
    @bulk_upload.update(result)

    if result[:successful]
      redirect_to @bulk_upload, flash: { success: t('bulk_uploads.upload_successful') }
    else
      redirect_to @bulk_upload, flash: { error: t('bulk_uploads.upload_error') }
    end
  end

  def create
    redirect_to(:back) && return unless params[:files].present?

    results = [] # store of all this BulkUpload's reports (successful and not)
    blocking_files = [] # store of this BulkUpload's invalid files ( { filename:, error_messages: } )

    ActiveRecord::Base.transaction do
      params[:files].each do |file|
        import = CsvImporter.import file.path
        results << import

        next if import[:successful]

        blocking_files.push({
                              filename: file.original_filename,
                              error_messages: import[:happy_accidents].map { |hash| hash[:message] }.uniq
                            })
      end

      raise ActiveRecord::Rollback unless blocking_files.empty?

      # Only reached if no files are 'blocking'
      results.each { |_result| BulkUpload.create results }
      return redirect_to bulk_uploads_path, flash: { success: t('bulk_uploads.upload_successful') }
    end

    error_message = generate_bulk_upload_error_message(blocking_files)

    redirect_to bulk_uploads_path, flash: { error: error_message }
  end

  def destroy
    (bulk_upload = BulkUpload.find(params[:id])) || raise_404
    bulk_upload.destroy

    redirect_to action: :index, notice: 'That bulk upload has been successfully deleted from the system. Thank you!'
  end

  private

  def generate_bulk_upload_error_message(blocking_files)
    error_message = t('bulk_uploads.upload_error')
    tab = "&nbsp;" * 4


    blocking_files.each do |file|
      error_message += [
        file[:filename],
        file[:error_messages].map { |message| tab + message }.flatten
      ].join("<br>")
    end

    error_message
  end
end
