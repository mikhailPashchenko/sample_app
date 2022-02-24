require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jar)
    @new_user = users(:new_client)
  end

  def logout_without_redirect
    login_as(@user)
    follow_redirect!
    delete logout_path
  end

  test "login with invalid params" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: 'nil', password: '' } }
    assert_template 'sessions/new'
    assert flash.any?
    get root_path
    assert flash.empty?
  end

  test "active user login with valid params" do
    login_as(@user)
    assert_redirected_to @user
    follow_redirect!
    assert_template :show
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert is_logged_in?
  end

  test "non-active user login with valid params" do
    login_as(@new_user)
    assert_redirected_to @new_user
    follow_redirect!
    assert_select "h1", "Hello, #{@new_user.name}!"
  end

  test "user log out" do
    logout_without_redirect
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "user log out 2 times" do
    logout_without_redirect
    follow_redirect!
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!

    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "log in with remember me" do
    login_as(@user, remember_me: '1')
    assert_not cookies[:remember_token].blank?
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "log in without remember" do
    login_as(@user)
    assert cookies[:remember_token].blank?
  end
end
