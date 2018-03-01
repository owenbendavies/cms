require 'rollbar/middleware/js'

module ApplicationHelper
  def body_class
    page_class = "page#{request.path.tr('/', '-')}"

    classes = [page_class]
    classes << page_class.gsub(/-edit$/, '')
    classes << 'loggedin' if user_signed_in?

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
    icon_tag('fas fa-check fa-fw') if boolean
  end

  def icon_tag(css_class)
    content_tag(:i, nil, class: css_class)
  end

  def rollbar_js
    Rollbar::Middleware::Js::SNIPPET
  end
end
