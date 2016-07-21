class ReportsController < ApplicationController
  # Authenticate user and load CanCanCan permissions
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    if search_params.any?
      @reports = Report.search(search_params)
    else
      @reports = Report.all
    end
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

  def search
    puts "Made it"
  end


  private
    def report_params
      {data: params.require(:report)[:data]}
    end

    def search_params
      # Strips rails default params and empty keys leaving only the populated search parameters
      p = params.except(:controller, :action, :utf8)
      p.delete_if { |k, v| v.empty? }
    end
end
