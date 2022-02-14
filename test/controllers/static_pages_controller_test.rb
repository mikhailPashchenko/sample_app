require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get home_path
    assert_response :success
    assert_select 'title', full_title('Home')
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select 'title', full_title('Help')
  end

  test "shoulg get about" do
    get about_path
    assert_response :success
    assert_select 'title', full_title('About')
  end

  test "should get contacts" do
    get contacts_path
    assert_response :success
    assert_select 'title', full_title('Contacts')
  end

  test "should get root" do
    get root_path
    assert_response :success
    assert_select 'title', full_title('Home')
  end
end
