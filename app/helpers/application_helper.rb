module ApplicationHelper



  def is_admin?
    return true
    if current_user
      return current_user.role == 'admin'
    else
      return false
    end
  end

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'current' : ''

    content_tag(:span, :class => class_name) do
      link_to link_text, link_path
    end
  end


end
