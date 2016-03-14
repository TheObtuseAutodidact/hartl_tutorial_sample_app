require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup info" do
    get signup_path

    assert_no_difference "User.count" do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "foo",
                               password_confirmation: "bar" }
    end
    assert_template "users/new"
    assert_select 'div.alert', "The form contains 4 errors"
    assert_select 'li', "Name can't be blank"
    assert_select 'li', "Email is invalid"
    assert_select 'li', "Password is too short (minimum is 6 characters)"
    assert_select 'li', "Password confirmation doesn't match Password"
  end

  test "valid signup info" do
    get signup_path
    assert_difference "User.count", 1 do
      post_via_redirect users_path user: { name: "Example User",
                                           email: "user@example.com",
                                           password: "password",
                                           password_confirmation: "password"}
    end
    assert_template "users/show"
    refute flash.empty?
  end
end
