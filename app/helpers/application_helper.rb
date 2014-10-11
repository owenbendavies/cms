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

  def flash_messages
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?

      type = type.to_sym
      type = :danger  if type == :error

      Array(message).each do |msg|
        button = content_tag(
          :button,
          raw("&times;"),
          :class => "close",
          "data-dismiss" => "alert"
        )

        text = content_tag(
          :div,
          button + msg,
          :class => "alert fade in alert-#{type}"
        )

        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end
