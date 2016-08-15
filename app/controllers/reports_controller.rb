class ReportsController < ApplicationController
  # Authenticate user and load CanCanCan permissions
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    if current_user.is_role?(:validator)
      @reports = Report.where("""data->>'state' = ? or id in (?)""", "submitted", current_user.validations.pluck(:report_id))
    else
      @reports = Report.search(search_params)
    end

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
        validators = ExpertiseMatcher.find_experts(@report)
        NotificationMailer.notify_validators_of_submitted_report(validators, @report).deliver_later if validators.any?
        NotificationMailer.notify_all_admins_of_submitted_report(@report).deliver_later
      end
      render json: @report, location: reports_path
    else
      head 422, location: reports_path
    end
  end

  def search
  end

  def export
    reports = @reports.pluck(:id)
    CsvExportJob.perform_later(reports, current_user)
    redirect_to reports_path, notice: "Your csv file is being generated. We will email you with a link to download it as soon as it is ready. Thank you"
  end

  def validate
    @validation = Validation.new
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
