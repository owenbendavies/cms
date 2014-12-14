class NoHtmlValidator < ActiveModel::EachValidator
  include ActionView::Helpers::SanitizeHelper

  def validate_each(record, attribute, value)
    return if !value.is_a?(String) || strip_tags(value) == value
    record.errors.add(attribute, :no_html)
  end
end
