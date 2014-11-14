#coding: utf-8

module FeatureHelpers
  extend ActiveSupport::Concern
  include Warden::Test::Helpers

  included do
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

  def visit_page(url)
    visit url
    expect(page.status_code).to eq 200
    expect(current_path).to eq url
  end

  def it_should_be_on_home_page
    expect(current_path).to eq '/home'
  end

  def its_body_id_should_be(body_id)
    expect(find('body')['id']).to eq body_id
  end

  def it_should_have_alert_with(text)
    expect(find('.alert').text).to eq "×#{text}"
  end

  def it_should_have_form_error(text)
    expect(find('.help-block').text).to eq text
  end

  RSpec.shared_context 'logged in account' do
    before do
      login_as @account

      if defined? go_to_url
        visit_page go_to_url
      else
        visit_page '/home'
      end
    end
  end

  RSpec.shared_context 'non logged in account' do
    before do
      visit_page go_to_url if defined? go_to_url
    end
  end

  RSpec.shared_context 'restricted page' do
    before do
      visit go_to_url
    end

    it 'redirects to login' do
      expect(current_path).to eq '/login'
    end
  end
end

RSpec.configuration.include FeatureHelpers, type: :feature
