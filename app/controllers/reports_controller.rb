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
    @live_apes  = Array.wrap(@report.data.dig('answers', 'live'))
    @dead_apes  = Array.wrap(@report.data.dig('answers', 'dead'))
    @body_parts = Array.wrap(@report.data.dig('answers', 'genus_parts', 'selected'))
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
        render json: @report, location: report_thank_you_path
      else
        render json: @report, location: reports_path
      end

    else
      head 422, location: reports_path
    end
  end

  def lock
    $redis.set("reports:#{params[:id]}:being_validated_by", current_user.id)
    $redis.expire("reports:#{params[:id]}:being_validated_by", 10)
    head 200
  end

  def search
    countries_list  = File.read('config/questionnaire/pages/incident/countries.json.erb')
    @countries      = JSON.parse(countries_list)
  end

  def export
    reports = @reports.pluck(:id)
    CsvExportJob.perform_later(reports, current_user)
    redirect_to reports_path, notice: t("csv_export.being_generated")
  end

  def validate
    if @report.is_being_validated? && @report.being_validated_by != current_user
      begin
        redirect_to :back, notice: "This report is currently being validated by another user."
      rescue ActionController::RedirectBackError
        redirect_to reports_path, notice: "This report is currently being validated by another user."
      end
    else
      @validation = Validation.new
    end
  end

  def thank_you
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
