require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

    def setup
      @user = users(:michael)
    end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)

    assert_template "users/edit"

    patch user_path(@user), user: { name: "",
                                    email: "foo@invalid",
                                    password: "foo",
                                    password_confirmation: "bar"}

    assert_template "users/edit"
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)

    assert_template "users/edit"

    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: {name: name,
                                   email: email,
                                   password: "",
                                   password_confirmation: ""}

    refute flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    refute session[:forwarding_url].nil?
    log_in_as(@user)

    assert_redirected_to edit_user_path(@user)

    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: {name: name,
                                   email: email,
                                   password: "",
                                   password_confirmation: ""}

    refute flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email

    get edit_user_path(@user)
    # log_in_as(@user) we are now logged in and therefore on the user's edit page
    assert_template "users/edit"
    assert session[:forwarding_url].nil?
  end

end
