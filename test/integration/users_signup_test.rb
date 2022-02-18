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

  test "valid user signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
                name: 'Valid User', email: 'valid@email.com',
                password: '12345', password_confirmation: '12345'
              }
      }
    end
    follow_redirect!
    assert_template :show
    assert_not flash.empty?
    assert is_logged_in?
  end
end
