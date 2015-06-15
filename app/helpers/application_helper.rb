module ApplicationHelper
  def body_id(path)
    'cms-page' + path.gsub('/', '-').gsub('-edit', '')
  end

  def page_title(site, content)
    title = [site.name]

    if !content.blank?
      title << content
    elsif !site.sub_title.blank?
      title << site.sub_title
    end

    title.join(' | ')
  end

  def footer_copyright(site)
    copyright_name = site.copyright || site.name
    copyright = "#{copyright_name} © #{Time.zone.now.year}"
    footer = [copyright]

    if site.charity_number
      footer << t('layouts.footer.charity', number: site.charity_number)
    end

    footer.join('. ')
  end
end
