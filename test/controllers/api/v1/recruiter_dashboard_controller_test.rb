require "test_helper"

class Api::V1::RecruiterDashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_recruiter_dashboard_index_url
    assert_response :success
  end
end
