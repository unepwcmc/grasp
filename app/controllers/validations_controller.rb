class ValidationsController < ApplicationController
  before_action :set_validation, only: [:show, :edit, :update, :destroy]

  # GET /validations
  def index
    @validations = Validation.all
  end

  # GET /validations/1
  def show
  end

  # GET /validations/new
  def new
    @validation = Validation.new
  end

  # GET /validations/1/edit
  def edit
  end

  # POST /validations
  def create
    @validation = Validation.new(validation_params)
    @validation.user = current_user
    @report = Report.find(params[:report_id])

    if params[:accept]
      @validation.state = "Validated"
      @report.state     = "Validated"
    elsif params[:return]
      @validation.state = "Returned"
      @report.state     = "Returned"
    end

    if @validation.save
      redirect_to @validation, notice: 'Validation was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /validations/1
  def update
    if @validation.update(validation_params)
      redirect_to @validation, notice: 'Validation was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /validations/1
  def destroy
    @validation.destroy
    redirect_to validations_url, notice: 'Validation was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_validation
      @validation = Validation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def validation_params
      params.require(:validation).permit(:state, :comments_for_provider, :comments_for_admin, :report_id)
    end
end
