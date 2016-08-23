class AgenciesController < ApplicationController
  before_action :set_agency, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /agencies
  def index
    @agencies = Agency.all
  end

  # GET /agencies/1
  def show
  end

  # GET /agencies/new
  def new
    @agency = Agency.new
  end

  # GET /agencies/1/edit
  def edit
  end

  # POST /agencies
  def create
    @agency = Agency.new(agency_params)

    if @agency.save
      redirect_to @agency, notice: t("admin.agencies.created")
    else
      render :new
    end
  end

  # PATCH/PUT /agencies/1
  def update
    if @agency.update(agency_params)
      redirect_to @agency, notice: t("admin.agencies.updated")
    else
      render :edit
    end
  end

  # DELETE /agencies/1
  def destroy
    @agency.destroy
    redirect_to agencies_url, notice: t("admin.agencies.destroyed")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agency
      @agency = Agency.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def agency_params
      params.require(:agency).permit(:name, :email, :url, :address_1, :address_1, :city, :post_code, :country)
    end
end
