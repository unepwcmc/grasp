class ReportsController < ApplicationController
  def index
    @reports = Report.all
  end

  def new
    @report = Questionnaire.load
  end

  def show
    @report = Report.find(params[:id])
  end

  def edit
    @report = Report.find(params[:id])
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      render json: @report, location: reports_path
    else
      head 422, location: reports_path
    end
  end

  def update
    @report = Report.find(params[:id])

    if @report.update(report_params)
      render json: @report, location: reports_path
    else
      head 422, location: reports_path
    end
  end

  private
    def report_params
      {data: params.require(:report)[:data]}
    end
end
