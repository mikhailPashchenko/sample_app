require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "edit" do
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
end
