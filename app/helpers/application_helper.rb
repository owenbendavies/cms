module ApplicationHelper
  def body_id(path)
    'cms-page' + path.tr('/', '-').gsub('-edit', '')
  end

  def body_class
    page_class = 'page' + request.path.tr('/', '-')

    classes = [page_class]
    classes << page_class.gsub(/-edit$/, '')
    classes += ['cms-loggedin', 'loggedin'] if user_signed_in?

    classes.sort.uniq.join(' ')
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
