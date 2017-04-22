require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test_user)
  end

  test "login with invalid information" do
    # Visit login path
    get login_path
    # Verify new seesion renders properly
    assert_template 'sessions/new'
    # Post invalid params hash
    post login_path, params: { session: { email: "", password: "" } }
    # Verify session is re-rendered AND a flash message appears
    assert_template 'sessions/new'
    assert_not flash.empty?
    # Visit another page
    get root_path
    # Verify flash message does NOT appear
    assert flash.empty?
  end

  test "login with valid information" do
    # Visit login path
    get login_path
    # Post valid information to the sessions path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'} }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'

    # Verify that the login link is gone
    assert_select "a[href=?]", login_path, count: 0
    # Verify that logout link is there
    assert_select "a[href=?]", logout_path
    # Verify that a profile link is also there
    assert_select "a[href=?]", user_path(@user)
  end
end
