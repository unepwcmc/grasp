class ReportsController < ApplicationController
  # Authenticate user and load CanCanCan permissions
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :load_questionnaire_template, only: [:show, :edit, :new]

  def index
    if current_user.is_role?(:validator)
      reports = Report.where("data->>'state' = :state or id in (:validated_report_ids)",
                  state: "submitted",
                  validated_report_ids: current_user.validations.pluck(:report_id)
                )
      @reports  = ExpertiseMatcher.filter_by_users_expertise(reports, current_user)
    elsif current_user.is_role?(:provider)
      user_page     = params[:table] == "user" ? params[:page] : 0
      user_reports  = current_user.reports
      @user_reports = Sorter.sort(user_reports, params[:sort], params[:dir]).page(user_page)

      agency_page     = params[:table] == "agency" ? params[:page] : 0
      agency_reports  = Report.accessible_by(current_ability)
      @agency_reports = Sorter.sort(agency_reports, params[:sort], params[:dir]).page(agency_page)
    else
      @reports = Report.search(search_params)
    end

    if @reports
      @reports = Sorter.sort(@reports, params[:sort], params[:dir]).page(params[:page])
    end
  end

  def new
  end

  def summary
    @report = Report.find(params[:id])
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
        NotificationMailer.notify_validators_of_submitted_report(@report).deliver_later
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

    def load_questionnaire_template
      @questionnaire_template = Questionnaire.load
    end
end
