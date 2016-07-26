require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  setup do
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
  end

  #test "should return all reports when get search with no params" do
    #2.times { |n| FactoryGirl.create(:report) }

    #get :index
    #assert_response :success
    #assert_equal 2, assigns(:reports).count
  #end

  #test "should search for specific report" do
    #2.times { |n| FactoryGirl.create(:report) }
    #@report = FactoryGirl.create(:report)

    #get :index, report_id: "1"
    #assert_response :success
    #assert_equal 1, assigns(:reports).count
    #assert_equal @report.id, assigns(:reports).first
  #end
end
