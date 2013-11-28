require 'spec_helper'

describe 'pages' do
  include_context 'default_site'
  include_context 'new_fields'

  describe 'new' do
    let(:go_to_url) { '/new' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has icon' do
        page.should have_selector 'h1 i.icon-plus'
      end

      it 'does not has page last updated in footer' do
        page.should_not have_content 'last updated'
      end

      it 'has page url on body' do
        its_body_id_should_be 'page_url_new'
      end

      it 'has tinymce' do
        page.body.should include 'tinyMCE.init'
        page.body.should include(
          "/assets/application.css,#{@site.stylesheet.url}"
        )
      end

      it 'has cancel link' do
        click_link 'Cancel'
        it_should_be_on_home_page
      end

      it 'creates a page' do
        fill_in 'Name', with: 'New Page'
        fill_in 'page[html_content]', with: "<p>#{new_message}</p>"

        expect {
          click_button 'Create Page'
        }.to change(Page, :count).by(1)

        new_page = Page.find_by_site_and_url(@site, 'new_page')
        new_page.name.should eq 'New Page'
        new_page.html_content.should eq "<p>#{new_message}</p>"
        new_page.created_by.should eq @account.id
        new_page.updated_by.should eq @account.id
        new_page.updated_from.should eq '127.0.0.1'
      end

      it 'shows errors' do
        fill_in 'Name', with: ''
        click_button 'Create Page'

        current_path.should eq '/'
        it_should_have_form_error "can't be blank"
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'New Page'
        end

        current_path.should eq '/new'
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
            find('h1').text.should eq 'Test Page'
          end
        end

        it 'has no link to edit' do
          page.should_not have_link 'Edit'
        end
      end

      it_behaves_like 'logged in account' do
        it 'shows the page' do
          within 'article' do
            find('h1').text.should eq 'Test Page'
          end
        end

        it 'has link to edit in topbar' do
          within('#topbar') do
            click_link 'Edit'
          end

          current_path.should eq '/test_page/edit'
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
        page.should_not have_selector 'article header h1'
      end
    end

    context 'private page' do
      let(:private_page) {
        FactoryGirl.create(:page, site_id: @site.id, private: true)
      }

      let(:go_to_url) { "/#{private_page.url}" }

      it_should_behave_like 'restricted page'

      it_behaves_like 'logged in account' do
        it 'shows page' do
          page.should have_selector 'h1 i.icon-lock'
        end
      end
    end
  end

  describe 'edit' do
    let(:go_to_url) { '/test_page/edit' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has icon' do
        page.should have_selector 'h1 i.icon-pencil'
      end

      it 'has page url on body' do
        its_body_id_should_be 'page_url_test_page'
      end

      it 'has tinymce' do
        page.body.should include 'tinyMCE.init'
        page.body.should include(
          "/assets/application.css,#{@site.stylesheet.url}"
        )
      end

      it 'has cancel link' do
        click_link 'Cancel'
        current_path.should eq '/test_page'
      end

      it 'edits the html content' do
        find_field('page[private]').should_not be_checked
        find_field('page[html_content]').value.should eq @test_page.html_content
        fill_in 'page[html_content]', with: "<p>#{new_message}</p>"
        click_button 'Update Page'

        current_path.should eq '/test_page'
        find('#main_article p').text.should eq new_message

        page = Page.find_by_site_and_url(@site, 'test_page')
        page.updated_by.should eq @account.id
        page.updated_from.should eq '127.0.0.1'
      end

      it 'makes a page private' do
        check 'Private'
        click_button 'Update Page'

        current_path.should eq '/test_page'
        page.should have_selector 'i.icon-lock'

        click_link 'Edit'
        find_field('page[private]').should be_checked
      end

      it 'renames a page' do
        find_field('Name')['autofocus'].should eq 'autofocus'
        fill_in 'Name', with: 'New Page Name'
        click_button 'Update Page'

        current_path.should eq '/new_page_name'
      end

      it 'does not save page with no edits' do
        test_page = Page.find_by_site_and_url(@site, 'test_page')
        test_page.updated_by = @account.id
        test_page.updated_from = '127.0.0.1'
        test_page.save!

        visit_page '/test_page/edit'

        expect {
          expect {
            fill_in 'page[html_content]', with: @test_page.html_content
            click_button 'Update Page'
            current_path.should eq '/test_page'
          }.to_not change{ Site.find_by_host!('localhost')._rev }
        }.to_not change{ Page.find_by_site_and_url(@site, 'test_page')._rev }
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
          find('h3').text.should eq 'Delete page?'

          find('.modal-body').text.should eq(
            "Are you sure you want to delete page 'Test Page'?"
          )

          click_link 'Delete'
        end

        current_path.should eq '/sitemap'
        it_should_have_alert_with 'Test Page was deleted'

        Page.find_by_site_and_url(@site, 'test_page').should be_nil

        deleted_page = Page.find_by_id(@test_page.id)
        deleted_page.deleted.should eq true
        deleted_page.updated_by.should eq @account.id
        deleted_page.updated_from.should eq '127.0.0.1'
      end

      it 'does not delete page on cancel', js: true do
        visit_page '/test_page'
        click_link 'Page'
        click_link 'Delete'

        within '.modal' do
          find('h3').text.should eq 'Delete page?'

          find('.modal-body').text.should eq(
            "Are you sure you want to delete page 'Test Page'?"
          )

          click_link 'Cancel'
        end

        current_path.should eq '/test_page'
        Page.find_by_site_and_url(@site, 'test_page').should eq @test_page
      end
    end
  end
end
