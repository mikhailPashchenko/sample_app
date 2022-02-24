require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:mike_admin)
    @user = users(:client)
    @other = users(:jar)
    @new_user = users(:new_client)
  end

  test "should get new" do
    get signup_path
    assert_response :success
    assert_select 'title', full_title('Sign up')
  end

  test "edit: should redirect to login without authentification" do
    get edit_user_path(@admin)
    assert_not flash.empty?
    assert_redirected_to "#{login_path}?from=edit_user"
  end

  test "update: should redirect to login without authentification" do
    patch user_path(@admin), params: { user: { name: 'Mishel', email: 'good@email.com',
                                      password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to "#{login_path}?from=update_user"
  end

  test "wrong edit when other non-admin user" do
    login_as(@other)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to user_path(@other)
  end

  test "wrong update when other non-admin user" do
    login_as(@other)
    patch user_path(@user), params: { user: { name: 'Mishel', email: 'good@email.com',
                                      password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to user_path(@other)
  end

  test "admin should edit other user" do
    login_as @admin
    get edit_user_path(@user)
    assert_response :success
    assert_template :edit
  end

  test "admin should update other user" do
    login_as @admin
    patch user_path(@other), params: { user: { name: 'Mishel', email: 'good@email.com',
                                      password: '', password_confirmation: '' } }

    assert_equal @other.reload.name, 'Mishel'
  end

  test "index should redirect to login without authentification" do
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
    login_as(@admin)
    get users_path
    assert_template :index
    assert @admin.is_god?
  end

  test "should not allow delete users for non-admin" do
    login_as @user
    delete user_path(@other)
    assert_redirected_to @user
    assert User.find_by(id: @other.id)
  end

  test "should allow delete users for admin" do
    login_as @admin
    delete user_path(@other)
    assert_redirected_to users_path
    assert_not User.find_by(id: @other.id)
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

  test "should allow edit active attribute via web" do
    assert_not @new_user.active?
    @new_user.set_activation_token
    get "/users/#{@new_user.id}/activate?token=#{@new_user.activation_token}"
    assert @new_user.reload.active?
  end

  test "should not activate if user active already" do
    get "/users/#{@user.id}/activate?token=#{@new_user.activation_token}"
    assert_redirected_to user_path(@user)
  end
end
