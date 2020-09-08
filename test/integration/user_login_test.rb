require "test_helper"

class UserLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :thuc
  end

  test "notification when redirect site" do
    get signin_url
    post signin_url, params: {session: {email: "", password: ""}}
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid infomation" do
    get signin_url
    post signin_url, params: {session: {
      email: @user.email,
      password: "password"
    }}
  end
end
