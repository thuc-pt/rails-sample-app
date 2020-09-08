require "test_helper"

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :thuc
  end

  test "unsuccessfully edit" do
    login_as @user
    get edit_user_url @user
    assert_template "users/edit"
    patch user_url(@user), params: {user: {name: "", email: ""}}
    assert_template "users/edit"
  end

  test "successfully edit" do
    login_as @user
    get edit_user_url @user
    assert_template "users/edit"
    patch user_url(@user), params: {user: {name: "Thuc PT", email: @user.email}}
  end
end
