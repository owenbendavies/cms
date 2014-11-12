#coding: utf-8

module ApplicationHelper
  def page_title(content)
    title = [@site.name]

    if not content.blank?
      title << content
    elsif not @site.sub_title.blank?
      title << @site.sub_title
    end

    title.join(' | ')
  end

  def footer_copyright
    copyright_name = @site.copyright || @site.name
    copyright = "#{copyright_name} © #{Time.now.year}"
    footer = [copyright]

    if @site.charity_number
      footer << t('layouts.footer.charity', number: @site.charity_number)
    end

    return footer.join('. ')
  end
end
