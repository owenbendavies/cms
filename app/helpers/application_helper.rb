module ApplicationHelper
  def body_id(path)
    'cms-page' + path.tr('/', '-').gsub('-edit', '')
  end

  def page_title(site, content)
    title = [site.name]

    if content.present?
      title << content
    elsif site.sub_title?
      title << site.sub_title
    end

    title.join(' | ')
  end

  def tick(boolean)
    content_tag(:i, nil, class: 'fa fa-check') if boolean
  end

  def icon_tag(icon)
    content_tag(:i, nil, class: "fa fa-#{icon}")
  end
end
