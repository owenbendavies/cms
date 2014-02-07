#coding: utf-8

module FeatureHelpers
  include Warden::Test::Helpers

  def visit_page(url)
    visit url
    page.status_code.should eq 200
    current_path.should eq url
  end

  def it_should_be_on_home_page
    current_path.should eq '/home'
  end

  def its_body_id_should_be(body_id)
    find('body')['id'].should eq body_id
  end

  def it_should_have_alert_with(text)
    find('.alert').text.should eq "×#{text}"
  end

  def it_should_have_form_error(text)
    find('.help-inline').text.should eq text
  end

  shared_context 'default_site' do
    before do
      Timecop.freeze('2012-03-12 09:23:05') do
        @account = FactoryGirl.create(:account)
        @site = FactoryGirl.create(:site)
        @features = FactoryGirl.create(:features)

        @home_page = FactoryGirl.create(
          :page,
          name: 'Home',
          site_id: @site.id
        )

        @test_page = FactoryGirl.create(
          :page,
          name: 'Test Page',
          site_id: @site.id
        )
      end
    end
  end

  shared_context 'logged in account' do
    before do
      login_as @account

      if defined? go_to_url
        visit_page go_to_url
      else
        visit_page '/home'
      end
    end
  end

  shared_context 'non logged in account' do
    before do
      visit_page go_to_url if defined? go_to_url
    end
  end

  shared_context 'restricted page' do
    before do
      visit go_to_url
    end

    it 'redirects to login' do
      current_path.should eq '/login'
    end
  end
end

RSpec.configuration.include FeatureHelpers, type: :feature
