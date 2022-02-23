require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:mike_admin)
  end

  test "bad params edit" do
    login_as(@user)
    get edit_user_path(@user)
    assert_template :edit
    patch user_path(@user), params: { user: { name: 'Nil', email: 'bad@email',
                                      password: '123', password_confirmation: '321' } }
    assert_template :edit
    assert_select ".alert.alert-danger", text: 'The form contains 3 errors.'
    assert_select "li", text: "Email is invalid"
    assert_select "li", text: "Password confirmation doesn't match Password"
    assert_select "li", text: "Password is too short (minimum is 4 characters)"
  end

  test "successful edit" do
    login_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { name: 'Mishel', email: 'good@email.com',
                                      password: '', password_confirmation: '' } }
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_select "h1", text: "Mishel"
    assert_select ".gravatar"
    # when user is logged in
    # assert_select ".email", text: "good@email.com"
  end

  test "succesfully edit after log in" do
    get edit_user_path(@user)
    login_as(@user)
    assert_redirected_to edit_user_path(@user)
  end
end
