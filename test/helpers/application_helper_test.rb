require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'application helper' do
    assert_equal full_title, 'Ruby on Rails Tutorial Sample App'
    assert_equal full_title('Home'), 'Home | Ruby on Rails Tutorial Sample App'
  end
end