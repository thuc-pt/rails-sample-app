module ApplicationHelper
  def full_title page_name
    if page_name.blank?
      I18n.t(".page_base")
    else
      page_name << " | " << I18n.t(".page_base")
    end
  end
end
