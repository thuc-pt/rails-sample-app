ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all

  def is_logged_in?
    session[:user].present?
  end

  def login_as user
    session[:user] = user.id
  end
end

class ActionDispatch::IntegrationTest
  def login_as user, password = "123456", remember = "1"
    post signin_url, params: {session: {
      email: user.email,
      password: password,
      remember: remember
    }}
  end
end
