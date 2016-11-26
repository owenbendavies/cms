RSpec.shared_context 'visit helpers' do
  alias_method :unchecked_visit, :visit

  def visit(*_)
    raise "Please use methods from #{__FILE__}"
  end

  def visit_non_redirect(url = go_to_url)
    unchecked_visit url
    expect(current_path).to eq URI.parse(url).path
    check_no_js_errors
  end

  def visit_200_page(url = go_to_url)
    visit_non_redirect url
    expect(page.status_code).to eq 200
  end

  def visit_404_page(url = go_to_url)
    visit_non_redirect url
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end

  def check_no_js_errors
    expect(page.driver.error_messages).to eq [] if page.driver.class == Capybara::Webkit::Driver
  end
end

RSpec.configuration.include_context 'visit helpers', type: :feature
