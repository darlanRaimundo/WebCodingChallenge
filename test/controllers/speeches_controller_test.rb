require "test_helper"

class SpeechesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get speeches_new_url
    assert_response :success
  end

  test "should get create" do
    get speeches_create_url
    assert_response :success
  end
end
