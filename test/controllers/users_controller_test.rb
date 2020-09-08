require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :thuc
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "check user login" do
    get edit_user_url @user
    assert_not flash.empty?
    assert_redirected_to "/en/signin"
  end
end
