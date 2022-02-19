require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
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
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template :show
    assert_select "a[href=?]", login_url, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert is_logged_in?
  end

  test "user log out" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    follow_redirect!
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", login_url
    assert_select "a[href=?]", logout_url, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
