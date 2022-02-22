require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  include SessionsHelper

  def setup
    @user = users(:jar)
    @other = users(:mike)
    remember_session(@user)
  end

  test "if user don't logged in" do
    forget_session(@user)
    assert_not logged_in?
  end

  test "current user is correct when when session was nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current user is nil when remember token is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_not current_user
    assert_not is_logged_in?
  end

  test "check current user? if other" do
    assert_not current_user?(@other)
  end

  test "check current user? if self" do
    assert current_user?(@user)
  end
end