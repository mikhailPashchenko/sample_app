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
    assert_redirected_to user_path(@user)
  end

  test "wrong update when other user" do
    login_as(@other)
    patch user_path(@user), params: { user: { name: 'Mishel', email: 'good@email.com',
                                      password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
  end
end
