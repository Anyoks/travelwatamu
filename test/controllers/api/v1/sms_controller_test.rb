require 'test_helper'

class Api::V1::SmsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_sms_create_url
    assert_response :success
  end

end
