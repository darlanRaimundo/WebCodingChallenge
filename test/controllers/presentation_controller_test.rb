require "test_helper"

class PresentationControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get presentation_new_url
    assert_response :success
  end

  test "should get create" do
    get presentation_create_url
    assert_response :success
  end
end
