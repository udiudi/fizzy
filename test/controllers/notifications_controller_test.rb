require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index and show back button" do
    sign_in_as users(:david)
    get notifications_url
    assert_response :success
    assert_select "a[href=?]", root_path do
      assert_select "strong", text: "Back to Home"
    end
  end
end
