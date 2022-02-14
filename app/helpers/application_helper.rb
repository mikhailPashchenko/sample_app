module ApplicationHelper

  VALID_EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    unless page_title.empty?
      base_title = page_title + ' | ' + base_title
    end
    base_title
  end
end
