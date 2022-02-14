require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout_links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", contacts_path, count: 1
    assert_select "title", full_title('Home')
  end
end
