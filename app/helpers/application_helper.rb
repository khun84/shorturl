module ApplicationHelper
  def home_link
    content_tag :a, href: '/' do
      'Home'
    end
  end
end
