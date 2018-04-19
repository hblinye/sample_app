module ApplicationHelper
  
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  def is_home(page_title = '')
    if not page_title.empty?
      true
    end
  end
  
end
