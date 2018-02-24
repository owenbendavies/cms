RSpec::Matchers.define :have_header do |title, icon|
  match do |page|
    header = page.find('.article__header')
    header.has_content?(title) && header.has_selector?(".fa-#{icon}")
  end
end
