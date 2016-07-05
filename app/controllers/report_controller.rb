class ReportController < ApplicationController
  def index
    @reports = Report.all
  end

  def new
    @report = Report.new
  end

  def create(report_params)
    @report = Report.new(report_params)
    if @report.save
      redirect_to :index, notice: "Report submitted successfully!"
    else
      redirect_to :index, notice: "There was an error submitting your report"
    end
  end

  private
    def report_params
      params.require(:report).permit(:data)
    end
end
