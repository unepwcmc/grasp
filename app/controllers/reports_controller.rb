class ReportsController < ApplicationController
  def index
    @reports = Report.all
  end

  def new
    @report = File.read(Rails.root.join("config/questionnaire.json"))
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      #head :created, location: reports_path
      render json: @report
    else
      head 422, location: reports_path
    end
  end

  def update
    @report = Report.find(params[:id])
    if @report.update(report_params)
      render json: @report
    else
      head 422, location: reports_path
    end
  end

  private
    def report_params
      {data: params.require(:report)[:data]}
    end
end
