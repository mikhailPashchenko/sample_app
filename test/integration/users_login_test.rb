require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @password = 'password'
  end

  def login_without_redirect
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: @password } }
  end

  def logout_without_redirect
    login_without_redirect
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

  test "login with valid params" do
    login_without_redirect
    assert_redirected_to @user
    follow_redirect!
    assert_template :show
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert is_logged_in?
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
end
