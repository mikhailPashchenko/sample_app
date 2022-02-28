require "test_helper"

class ActivateAccountTest < ActionDispatch::IntegrationTest

  def setup
    @new_user = users(:new_client)
    @user = users(:jar)
    
  end

  test "should not activate account if token is incorrect" do
    assert_not @new_user.active?
    get "/users/#{@new_user.id}/activate?token=fhh34jklhdrjklrmfmiop"
    assert_not @new_user.reload.active?
  end

  test "should activate account by link" do
    assert_not @new_user.active?
    get "/users/#{@new_user.id}/activate?token=#{@new_user.activation_token}"
    assert @new_user.reload.active?
  end

  test "should not activate if user is active already" do
    assert @user.active?
    get "/users/#{@user.id}/activate?token=#{@new_user.activation_token}"
    assert_redirected_to user_path(@user)
  end

end
