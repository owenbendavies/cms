require 'rollbar/middleware/js'

module ApplicationHelper
  def body_class
    page_class = "page#{request.path.tr('/', '-')}"

    classes = [page_class]
    classes << page_class.gsub(/-edit$/, '')
    classes << 'loggedin' if current_user

    classes.sort.uniq.join(' ')
  end

  def copyright(site)
    "#{site.name} © #{Time.zone.now.year}"
  end

  def icon_tag(css_class)
    content_tag(:i, nil, class: css_class)
  end

  def page_title(site, content)
    [site.name, content].compact.join(' | ')
  end

  def privacy_policy_link(site, url: false)
    privacy_policy = site.privacy_policy_page
    url_method = url ? :page_url : :page_path

    link_to(
      privacy_policy.name,
      send(url_method, privacy_policy.url),
      target: '_blank',
      rel: 'noopener'
    )
  end

  def site_stylesheet(site)
    md5 = Digest::MD5.hexdigest(site.css)
    id = "#{site.id}-#{md5}"
    asset_path(css_path(id, format: 'css'))
  end

  def timeago(time)
    content_tag(:time, time.to_s(:short), class: 'js-timeago', datetime: time.iso8601)
  end

  def rollbar_js
    Rollbar::Middleware::Js::SNIPPET
  end

  def yes_no(boolean)
    boolean ? t('yes') : t('no')
  end
end
