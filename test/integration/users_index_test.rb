require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  test "test users count shoul be greater then 30" do
    assert User.count > 30
  end

  def setup
    @admin = users(:mike_admin)
    @client = users(:client)
    @last_user = User.last
  end

  test "index should have pagination with 2 pages" do
    login_as(@client)
    get users_path
    assert_select "div.pagination", count: 2
    assert_select "a[href=?]", "#{users_path}?page=2"
  end

  test "index should have first page with users" do
    login_as(@client)
    get users_path
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end

  test "click next page should redirect to page 2" do
    login_as(@client)
    get users_path
    assert_select "a[rel=next]", href: "#{users_path}?page=2"
    get "#{users_path}?page=2"
    User.paginate(page: 2).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end

  test "non-admin should not see delete links" do
    login_as(@client)
    get users_path
    assert_select "a", text: 'delete', count: 0
  end

  test "admin should see delete links except for himself" do
    login_as(@admin)
    get users_path
    assert_select "a", text: 'delete', count: 29
    assert_select "a[href=?]", user_path(@admin), text: "delete", count: 0
  end
end
