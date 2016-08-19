require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  setup do
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
    2.times { |n| FactoryGirl.create(:report) }
  end

  test "should return all reports when get search with no params" do
    get :index
    assert_response :success
    assert_equal 2, assigns(:reports).count
  end

  test "should search for a specific report by id" do
    @report = FactoryGirl.create(:report)

    get :index, report_id: @report.id
    assert_response :success
    assert_equal 1, assigns(:reports).count
    assert_equal @report.id, assigns(:reports).first.id
  end

  test "should search for reports by country of discovery" do
    @report = FactoryGirl.create(:report, data: {
      'answers': {
        'country_of_discovery': {
          'selected': 'Mali'
        }
      }
    })

    get :index, country_of_discovery: 'Mali'
    assert_response :success
    assert_equal 1, assigns(:reports).count
    assert_equal @report.id, assigns(:reports).first.id
  end

  test "should search for reports by date range" do
    @report   = FactoryGirl.create(:report, created_at: Date.today- 1.day)
    date_f    = Date.today - 2.days
    date_t    = Date.today - 1.day
    from_date = {"(1i)": date_f.year, "(2i)": date_f.month, "(3i)": date_f.day}
    to_date   = {"(1i)": date_t.year, "(2i)": date_t.month, "(3i)": date_t.day}

    get :index, from_date: from_date, to_date: to_date
    assert_response :success
    assert_equal 1, assigns(:reports).count
    assert_equal @report.id, assigns(:reports).first.id
  end

  test "should search for reports by agencies" do
    @agency   = FactoryGirl.create(:agency)
    @provider = FactoryGirl.create(:user, agency: @agency)
    @report   = FactoryGirl.create(:report, user: @provider)

    get :index, agencies: [@agency.id.to_s]
    assert_response :success
    assert_equal 1, assigns(:reports).count
    assert_equal @report.id, assigns(:reports).first.id
  end

  test "should search for reports by genus" do
    FactoryGirl.create(:report, data: {
      'answers': {
        'genus_dead': {
          'selected': 'Gorilla (gorilla)'
        }
      }
    })

    @report = FactoryGirl.create(:report, data: {
      'answers': {
        'genus_live': {
          'selected': 'Gorilla (gorilla)'
        }
      }
    })

    get :index, status_live: "1", genus: ['Gorilla (gorilla)']
    assert_response :success
    assert_equal 1, assigns(:reports).count
    assert_equal @report.id, assigns(:reports).first.id
  end

  test "should search for reports by user" do
    @provider = FactoryGirl.create(:provider)
    @report   = FactoryGirl.create(:report, user: @provider)
    get :index, users: [@provider.id.to_s]
    assert_response :success
    assert_equal 1, assigns(:reports).count
    assert_equal @report.id, assigns(:reports).first.id
  end

  test "should search for reports by last known location" do
    @report = FactoryGirl.create(:report, data: {
      'answers': {
        'last_known_location_parts': {
          'selected': 'At location of incident'
        }
      }
    })

    get :index, last_known_location: ['At location of incident']
    assert_response :success
    assert_equal 1, assigns(:reports).count
    assert_equal @report.id, assigns(:reports).first.id
  end

  test "should search for reports by ape name" do
    @report = FactoryGirl.create(:report, data: {
      'answers': {
        'individual_name_dead': {
          'selected': 'Fred'
        }
      }
    })

    get :index, ape_name: "Fred"
    assert_response :success
    assert_equal 1, assigns(:reports).count
    assert_equal @report.id, assigns(:reports).first.id
  end

  test "should search for reports by ape name (case insensitive and partial completion)" do
    @report = FactoryGirl.create(:report, data: {
      'answers': {
        'individual_name_dead': {
          'selected': 'Fred'
        }
      }
    })

    get :index, ape_name: "fre"
    assert_response :success
    assert_equal 1, assigns(:reports).count
    assert_equal @report.id, assigns(:reports).first.id
  end

  test "should assign user_reports for provider" do
    provider = FactoryGirl.create(:provider)
    sign_in provider

    user_report = FactoryGirl.create(:report, user: provider)
    _other_user_report = FactoryGirl.create(:report)

    get :index
    assert_response :success
    assert_equal 1, assigns(:user_reports).count
    assert_equal user_report.id, assigns(:user_reports).first.id
  end

  test "should assign agency_reports for provider" do
    agency = FactoryGirl.create(:agency)
    provider = FactoryGirl.create(:provider, agency: agency)
    agency_report = FactoryGirl.create(:report, user: provider)

    other_agency = FactoryGirl.create(:agency)
    other_provider = FactoryGirl.create(:provider, agency: other_agency)
    _other_agency_report = FactoryGirl.create(:report, user: other_provider)

    sign_in provider
    get :index
    assert_response :success
    assert_equal 1, assigns(:agency_reports).count
    assert_equal agency_report.id, assigns(:agency_reports).first.id
  end
end
