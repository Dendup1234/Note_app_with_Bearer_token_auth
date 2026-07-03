require "test_helper"

class Api::V1::StudentProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_v1_student_profiles_show_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_student_profiles_update_url
    assert_response :success
  end
end
