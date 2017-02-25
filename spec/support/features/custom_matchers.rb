RSpec::Matchers.define :have_header do |title, icon|
  match do |page|
    header = page.find('#cms-article-header')
    header.has_content?(title) && header.has_selector?(".fa-#{icon}")
  end
end
