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
      head :created, location: reports_path
    else
      head 422, location: reports_path
    end
  end

  private
    def report_params
      params.require(:report).permit(:data)
    end
end
