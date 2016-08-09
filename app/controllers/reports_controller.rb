class ReportsController < ApplicationController
  # Authenticate user and load CanCanCan permissions
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @reports = Report.search(search_params)
    @reports = Sorter.sort(
      @reports, params[:sort], params[:dir]
    ).page(params[:page])
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
    @report.user = current_user

    if @report.save
      render json: @report, location: reports_path
    else
      head 422, location: reports_path
    end
  end

  def update
    @report = Report.find(params[:id])

    if @report.update(report_params)
      if @report.state == "Submitted"
        ::NotificationMailer.notify_all_admins_of_submitted_report(@report).deliver_later
      end
      render json: @report, location: reports_path
    else
      head 422, location: reports_path
    end
  end

  def search
  end

  private
    def report_params
      {data: params.require(:report)[:data]}
    end

    def search_params
      p = ParamsUtils.strip_rails_defaults(params)
      ParamsUtils.strip_empty(p)
    end
end
