require 'rollbar/middleware/js'

module ApplicationHelper
  def body_class
    page_class = "page#{request.path.tr('/', '-')}"

    classes = [page_class]
    classes << page_class.gsub(/-edit$/, '')
    classes << 'loggedin' if current_user
    classes.sort!
    classes.uniq!
    classes.join(' ')
  end

  def copyright(site)
    "#{site.name} © #{Time.zone.now.year}"
  end

  def icon_tag(css_class)
    tag.i(class: css_class)
  end

  def page_title(site, content)
    [site.name, content].compact.join(' | ')
  end

  def privacy_policy_link(site, url: false)
    privacy_policy = site.privacy_policy_page
    url_method = url ? :page_url : :page_path

    link_to(privacy_policy.name, public_send(url_method, privacy_policy.url), target: '_blank', rel: 'noopener')
  end

  def site_stylesheet(site)
    md5 = Digest::MD5.hexdigest(site.css)
    asset_path(css_path(md5, format: 'css'))
  end

  def timeago(time)
    tag.time(time.to_s(:short), class: 'js-timeago', datetime: time.iso8601)
  end

  def rollbar_js
    Rollbar::Middleware::Js::SNIPPET
  end

  def yes_no(boolean)
    boolean ? t('yes') : t('no')
  end
end
