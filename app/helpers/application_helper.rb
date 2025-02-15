module ApplicationHelper

  # Return unique title for each page
  def full_title (page_title = '')
    base_title = Rails.application.config.TITLE
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end
end
