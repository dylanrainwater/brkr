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

  test "login with valid information followed by logout" do
    # Visit login path
    get login_path
    # Post valid information to the sessions path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'} }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'

    # Verify that the login link is gone
    assert_select "a[href=?]", login_path, count: 0
    # Verify that logout link is there
    assert_select "a[href=?]", logout_path
    # Verify that a profile link is also there
    assert_select "a[href=?]", user_path(@user)

    # log out
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    # log out, again (another browser or session)
    delete logout_path
    follow_redirect!

    # Verify that the login link is back
    assert_select "a[href=?]", login_path
    # Verify that logout link is gone
    assert_select "a[href=?]", logout_path, count: 0
    # Verify that a profile link is also gone
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  # Tests use strings for cookies instead of symbols
  test "login and remember" do
    log_in_as(@user)
    assert_not_empty cookies['remember_token']
  end

  test "login do not remember" do
    # Should set cookie
    log_in_as(@user)
    # Should delete the cookie
    log_in_as(@user, remember_me: '0')

    assert_empty cookies['remember_token']
  end
end
