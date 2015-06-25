require 'rails_helper'

RSpec.describe 'application layout', type: :feature do
  it_behaves_like 'non logged in user' do
    before { visit_page '/test_page' }

    it 'has page url as body id' do
      expect(find('body')['id']).to eq 'cms-page-test_page'
    end

    it 'has no topbar' do
      expect(page).to have_no_selector '#cms-topbar'
    end
  end

  it_behaves_like 'logged in user' do
    describe 'topbar' do
      let(:topbar) { find('#cms-topbar') }

      it 'has link to home' do
        expect(topbar).to have_link site.name, href: '/'
      end

      it 'has dropdowns', js: true do
        within '#cms-topbar' do
          expect(page).to_not have_link 'Toggle navigation'
          expect(page).to_not have_link 'Messages'

          click_link 'Site'
          click_link 'Messages'
        end
      end

      it 'has mobile dropdowns', js: true do
        windows.first.resize_to 640, 1136

        within '#cms-topbar' do
          expect(page).to_not have_link 'Site'
          expect(page).to_not have_link 'Messages'

          click_button 'Toggle navigation'

          expect(page).to_not have_link 'Messages'

          click_link 'Site'
          click_link 'Messages'
        end
      end
    end
  end
end
