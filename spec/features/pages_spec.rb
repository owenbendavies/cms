require 'rails_helper'

RSpec.describe 'pages', type: :feature do
  describe 'new' do
    let(:go_to_url) { '/new' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has icon' do
        expect(page).to have_selector 'h1 i.glyphicon-plus'
      end

      it 'does not has page last updated in footer' do
        expect(page).to have_no_content 'last updated'
      end

      it 'has page url on body' do
        its_body_id_should_be 'page_url_new'
      end

      it 'has cancel link' do
        click_link 'Cancel'
        it_should_be_on_home_page
      end

      it 'creates a page', js: true do
        fill_in 'Name', with: 'New Page'

        page.execute_script("tinyMCE.editors[0].setContent('#{new_message}');")

        expect {
          click_button 'Create Page'
          expect(page).to have_content 'New Page'
        }.to change(Page, :count).by(1)

        new_page = Page.find_by_site_and_url(site, 'new_page')
        expect(new_page.name).to eq 'New Page'
        expect(new_page.html_content).to eq "<p>#{new_message}</p>"
        expect(new_page.created_by).to eq account.id
        expect(new_page.updated_by).to eq account.id
      end

      it 'shows errors' do
        fill_in 'Name', with: ''
        click_button 'Create Page'

        expect(current_path).to eq '/'
        it_should_have_form_error "can't be blank"
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'New Page'
        end

        expect(current_path).to eq '/new'
      end
    end
  end

  describe 'show' do
    context 'test_page' do
      let(:go_to_url) { '/test_page' }

      it_behaves_like 'non logged in account' do
        it 'has page url on body' do
          its_body_id_should_be 'page_url_test_page'
        end

        it 'shows page name in header' do
          within 'article' do
            expect(find('h1').text).to eq 'Test Page'
          end
        end

        it 'has no link to edit' do
          expect(page).to have_no_link 'Edit'
        end
      end

      it_behaves_like 'logged in account' do
        it 'shows the page' do
          within 'article' do
            expect(find('h1').text).to eq 'Test Page'
          end
        end

        it 'has link to edit in topbar' do
          within('#topbar') do
            click_link 'Edit'
          end

          expect(current_path).to eq '/test_page/edit'
        end
      end
    end

    context 'home' do
      before do
        visit_page '/home'
      end

      it 'has page url on body' do
        its_body_id_should_be 'page_url_home'
      end

      it 'does not show header' do
        expect(page).to have_no_selector 'article header h1'
      end
    end

    context 'private page' do
      let(:private_page) {
        FactoryGirl.create(:page, site_id: site.id, private: true)
      }

      let(:go_to_url) { "/#{private_page.url}" }

      it_should_behave_like 'restricted page'

      it_behaves_like 'logged in account' do
        it 'shows page' do
          expect(page).to have_selector 'h1 i.glyphicon-lock'
        end
      end
    end
  end

  describe 'edit' do
    let(:go_to_url) { '/test_page/edit' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has icon' do
        expect(page).to have_selector 'h1 i.glyphicon-pencil'
      end

      it 'has page url on body' do
        its_body_id_should_be 'page_url_test_page'
      end

      it 'has cancel link' do
        click_link 'Cancel'
        expect(current_path).to eq '/test_page'
      end

      it 'edits the html content', js: true do
        expect(body).to include test_page.html_content

        page.execute_script("tinyMCE.editors[0].setContent('#{new_message}');")

        click_button 'Update Page'

        expect(current_path).to eq '/test_page'
        expect(find('#main_article p').text).to eq new_message

        page = Page.find_by_site_and_url(site, 'test_page')
        expect(page.updated_by).to eq account.id
      end

      it 'makes a page private' do
        expect(find_field('page[private]')).not_to be_checked
        check 'Private'
        click_button 'Update Page'

        expect(current_path).to eq '/test_page'
        expect(page).to have_selector 'i.glyphicon-lock'

        click_link 'Edit'
        expect(find_field('page[private]')).to be_checked
      end

      it 'adds a contact form' do
        expect(find_field('page[contact_form]')).not_to be_checked
        check 'Contact Form'
        click_button 'Update Page'

        expect(current_path).to eq '/test_page'
        expect(page).to have_content 'Name'

        click_link 'Edit'
        expect(find_field('page[contact_form]')).to be_checked
      end

      it 'renames a page' do
        expect(find_field('Name')['autofocus']).to eq 'autofocus'
        fill_in 'Name', with: 'New Page Name'
        click_button 'Update Page'

        expect(current_path).to eq '/new_page_name'
      end

      it 'does not save page with no edits' do
        test_page = Page.find_by_site_and_url(site, 'test_page')
        test_page.updated_by = account.id
        test_page.save!

        visit_page '/test_page/edit'

        expect {
          expect {
            fill_in 'page[name]', with: test_page.name
            click_button 'Update Page'
            expect(current_path).to eq '/test_page'
          }.to_not change{ Site.find_by_host('localhost')._rev }
        }.to_not change{ Page.find_by_site_and_url(site, 'test_page')._rev }
      end

      it 'shows errors' do
        fill_in 'page[name]', with: ''
        click_button 'Update Page'
        it_should_have_form_error "can't be blank"
      end
    end
  end

  describe 'delete' do
    it_behaves_like 'logged in account' do
      it 'deletes a page', js: true do
        visit_page '/test_page'
        click_link 'Page'
        click_link 'Delete'

        within '.modal' do
          expect(page).to have_content('Delete page?')

          expect(find('.modal-body').text).to eq(
            "Are you sure you want to delete page 'Test Page'?"
          )

          expect {
            click_link 'Delete'
            expect(page.body).to include('Test Page was deleted')
          }.to change(Page, :count).by(-1)
        end

        it_should_have_alert_with 'Test Page was deleted'
        expect(current_path).to eq '/sitemap'
        expect(Page.find_by_site_and_url(site, 'test_page')).to be_nil
      end

      it 'does not delete page on cancel', js: true do
        visit_page '/test_page'
        click_link 'Page'
        click_link 'Delete'

        within '.modal' do
          expect(page).to have_content('Delete page?')

          expect(find('.modal-body').text).to eq(
            "Are you sure you want to delete page 'Test Page'?"
          )

          expect {
            click_link 'Cancel'
            expect(current_path).to eq '/test_page'
          }.to_not change(Page, :count)
        end

        expect(current_path).to eq '/test_page'
        expect(Page.find_by_site_and_url(site, 'test_page')).to eq test_page
      end
    end
  end
end
