require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid user signups" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
                name: 'invalid_user', email: '',
                password: '12345', password_confirmation: '12345'
              }
      }
    end
    assert_template :new
    assert_select "#error_explanation"
    assert_select "div.alert.alert-danger"
  end
end