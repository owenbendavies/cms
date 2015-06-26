require 'rails_helper'

RSpec.describe 'application layout', type: :feature do
  it_behaves_like 'non logged in user' do
    before { visit_page '/test_page' }

    it 'has page url as body id' do
      expect(find('body')['id']).to eq 'cms-page-test_page'
    end
  end
end
