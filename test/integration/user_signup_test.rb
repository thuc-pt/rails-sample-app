require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  test "valid sign up" do
    get signup_url
    assert_no_difference "User.count" do
      post users_url, params: {user: {
        name: "abc",
        email: "test@email.com",
        password: "123456",
        password_confirmation: "654321"
      }}
    end
  end

  test "valid sign up infomation" do
    get signup_url
    assert_difference "User.count", 1 do
      post users_url, params: {user: {
        name: "Examples user",
        email: "example@yahoo.com",
        password: "123456",
        password_confirmation: "123456"
      }}
    end
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
    assert is_logged_in?
  end
end
