require "test_helper"

class Api::V1::RecruiterProfileControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_v1_recruiter_profile_show_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_recruiter_profile_update_url
    assert_response :success
  end
end
