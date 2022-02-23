require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  test "test users count shoul be greater then 30" do
    assert User.count > 30
  end

  def setup
    @user = users(:mike_admin)
    @last_user = User.last
    login_as(@user)
    get users_path
  end

  test "index should have pagination with 2 pages" do
    assert_select "div.pagination", count: 2
    assert_select "a[href=?]", "#{users_path}?page=2"
  end

  test "index should have first page with users" do
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end

  test "click next page should redirect to page 2" do
    assert_select "a[rel=next]", href: "#{users_path}?page=2"
    get "#{users_path}?page=2"
    User.paginate(page: 2).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end
end
