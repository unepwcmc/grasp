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
      @user_reports = Sorters::Reports.sort(user_reports, params[:sort], params[:dir]).page(user_page)

      agency_page     = params[:table] == "agency" ? params[:page] : 0
      agency_reports  = Report.accessible_by(current_ability)
      @agency_reports = Sorters::Reports.sort(agency_reports, params[:sort], params[:dir]).page(agency_page)
    else
      @reports = Report.search(search_params)
    end

    if @reports
      @reports = Sorters::Reports.sort(@reports, params[:sort], params[:dir]).page(params[:page])
    end
  end

  def new
  end

  def summary
    @report = Report.find(params[:id])
    @matched_validators = ExpertiseMatcher.find_experts(@report)
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
    old_state = @report.state

    if @report.update(report_params)
      if @report.state == "Submitted" && old_state != @report.state
        ExpertiseMatcher.find_experts(@report).each do |validator|
          NotificationMailer.notify_validator_of_submitted_report(@report, validator).deliver_later
        end

        User.all_admins.each do |admin|
          NotificationMailer.notify_admin_of_submitted_report(@report, admin).deliver_later
        end

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
    @countries = CountryUtilities.all_countries

    # Find date of earliest record, to limit the date range filters.
    report_dates = Report.pluck("data -> 'answers' -> 'date_of_discovery' -> 'selected'").compact
    report_years = report_dates.map { |report_date| report_date.split('/').last }
    
    @earliest_report_year = report_years.present? ? report_years.uniq.min.to_i : 1950
  end

  def export
    reports = Report.search(search_params).pluck(:id)
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
      @live_apes  = Array.wrap(@report.data.dig('answers', 'live'))
      @dead_apes  = Array.wrap(@report.data.dig('answers', 'dead'))
      @body_parts = Array.wrap(@report.data.dig('answers', 'genus_parts', 'selected'))
    end
  end

  def thank_you
  end

  def destroy
    Report.find(params['id']).destroy
    flash[:success] = "The report with ID #{params['id']} has been successfully deleted from the system."
    redirect_to action: :index
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
