require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Thuc", email: "phantrongthuc20@gmail.com",
      password: "202201", password_confirmation: "202201")
  end

  test "is user valid?" do
    assert @user.valid?
  end

  test "check name blank?" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "check name size" do
    @user.name = @user.name * 10
    assert_not @user.valid?
  end

  test "check format email" do
    list_emails = %w(user@example.com USER@foo.COM)
    list_emails.each do |mail|
      @user.email = mail
      assert @user.valid?
    end
  end

  test "check unique email" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "check email saved as lower-case" do
    mixed_email = "ThucPT@gmail.com"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end

  test "check password blank?" do
    @user.password = " "
    assert_not @user.valid?
  end

  test "check minimum length password" do
    @user.password = @user.password_confirmation = "12345"
    assert_not @user.valid?
  end

  test "authenticate? return false with user nil digest" do
    assert_not @user.authenticate? ""
  end
end
