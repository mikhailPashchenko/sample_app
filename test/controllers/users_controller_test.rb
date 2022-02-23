require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:mike)
    @other = users(:jar)
  end

  test "should get new" do
    get signup_path
    assert_response :success
    assert_select 'title', full_title('Sign up')
  end

  test "edit: should redirect to login without authentification" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to "#{login_path}?from=edit_user"
  end

  test "update: should redirect to login without authentification" do
    patch user_path(@user), params: { user: { name: 'Mishel', email: 'good@email.com',
                                      password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to "#{login_path}?from=update_user"
  end

  test "wrong edit when other user" do
    login_as(@other)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to user_path(@other)
  end

  test "wrong update when other user" do
    login_as(@other)
    patch user_path(@user), params: { user: { name: 'Mishel', email: 'good@email.com',
                                      password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to user_path(@other)
  end

  test "index should redirect when isn't log in" do
    get users_path
    assert_redirected_to "#{login_path}?from=index_user"
  end

  test "should get index when is log in" do
    login_as(@user)
    get users_path
    assert_response :success
    assert_template :index
  end

  test "admin user on index should be god" do
    login_as(users :mike)
    get users_path
    assert_template :index
    assert @user.is_god?
  end

  test "should not allow edit role attribute via web" do
    login_as @other
    assert_equal @other.role, 'client'
    patch user_path(@other), params: { user: {
      password: "password",
      password_confirmation: "password",
      role: 'admin'
    }}
    assert_equal @other.reload.role, 'client'
  end
end
