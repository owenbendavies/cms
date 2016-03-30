RSpec.shared_context 'visit helpers', type: :feature do
  alias_method :unchecked_visit, :visit

  def visit(*_)
    raise 'Please use methods from spec/support/features/visit.rb'
  end

  def visit_non_redirect(url = go_to_url)
    unchecked_visit url
    expect(current_path).to eq URI.parse(url).path
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
end
